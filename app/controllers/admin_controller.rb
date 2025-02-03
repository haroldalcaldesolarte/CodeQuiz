class AdminController < ApplicationController
  def index
  
  end

  def upload_questions
    begin
      raise "Solo pueden usar esta funcionalidad profesores o administradores" unless current_user.superuser?

      file = params[:file]
      raise "Debe cargar un archivo JSON" if file.blank?

      unless File.extname(file.original_filename).downcase == ".json"
        raise "El archivo debe tener la extensión .json."
      end

      json_content = file.read
      raise "El archivo JSON está vacío" if json_content.strip.empty?

      json_data = JSON.parse(json_content)
      raise "El archivo JSON está mal formado." if json_data.blank?

      errors = validate_questions(json_data['questions'])

      if errors.any?
        raise errors.join("\n")
      end

      #Si no hay errores en el JSON creamos las preguntas y respuestas
      ActiveRecord::Base.transaction do
        json_data['questions'].each do |question_data|
          create_question_and_answers(question_data)
        end
      end

      render json: { success: true, message: "Preguntas cargadas exitosamente." }, status: :ok
    rescue Exception => e
      render json: { success: false, message: e.message }, status: :unprocessable_entity
    end
  end

  private

    def validate_questions(questions)
      errors = []
      valid_statuses = Question.statuses.values

      questions.each_with_index do |question_data, index|
        if question_data['text'].blank?
          errors << "Pregunta ##{index + 1}: El campo 'text' no puede estar vacío."
        end

        if question_data.key?('status')
          unless question_data['status'].in?(valid_statuses)
            errors << "Pregunta ##{index + 1}: El status '#{question_data['status']}' no es válido. Debe ser 'pending', 'approved' o 'rejected'."
          end
        end

        category = Category.find_by(id: question_data['category_id'])
        if category.nil?
          errors << "Pregunta ##{index + 1}: La categoría con el ID: '#{question_data['category_id']}' no existe."
        end

        level = Level.find_by(id: question_data['level_id'])
        if level.nil?
          errors << "Pregunta ##{index + 1}: El nivel con el ID: '#{question_data['level_id']}' no existe."
        end

        if question_data['answers'].nil? || !question_data['answers'].is_a?(Array) || question_data['answers'].size != 4
          errors << "Pregunta ##{index + 1}: Debe tener exactamente 4 respuestas."
        else
          correct_answers = question_data['answers'].select { |a| a['correct'] == true }
          if correct_answers.size != 1
            errors << "Pregunta ##{index + 1}: Debe haber exactamente una respuesta correcta."
          end
  
          question_data['answers'].each_with_index do |answer, a_index|
            if answer['text'].blank?
              errors << "Pregunta ##{index + 1}, Respuesta ##{a_index + 1}: El campo 'text' no puede estar vacío."
            end
          end
        end
      end
      errors
    end

    def create_question_and_answers(question_data)
      category = Category.find(question_data['category_id'])
      level = Level.find(question_data['level_id'])
  
      question = Question.create!(
        question_text: question_data['text'],
        category: category,
        level: level,
        status: question_data.key?('status') ? question_data['status'] : 0,
        author_id: question_data.key?('author_id') ? question_data['author_id'] : current_user.id,
        revisor_id: question_data.key?('revisor_id') ? question_data['revisor_id'] : current_user.id
      )
  
      question_data['answers'].each do |answer_data|
        question.answers.create!(
          answer_text: answer_data['text'],
          correct: answer_data['correct']
        )
      end
    end
end

