class AdminController < ApplicationController
  def index
  
  end

  def uploadQuestions
    #CONTROL MAS FERREO, 
    # Comprobar que tiene categoria valida, text, level valido
    # Lo mismo para las respuestas, que sean 4 y que haya una correcta
    # Si no que no deje crear ninguna respuesta
    #Indicar en la vista el formato de JSON que tiene que tener para que lo hagan correctamente
    

    file = params[:file]
    data = JSON.parse(file.read)

    data.each do |question_data|
      author_id = question_data.has_key?(:author_id) ? question_data[:author_id] : current_user.id
      revisor_id = question_data.has_key?(:revisor_id) ? question_data[:revisor_id]: current_user.id 
      approved = question_data.has_key?(:approved) ? question_data[:approved] : true
      question = Question.create!(
        question_text: question_data['text'],
        category_id: question_data['category_id'],
        level_id: question_data['level_id'],
        approved: approved,
        author_id: author_id,
        revisor_id: revisor_id
      )

      question_data['answers'].each do |answer_data|
        question.answers.create!(answer_text: answer_data['text'], correct: answer_data['correct'])
      end
    end
  end
end

