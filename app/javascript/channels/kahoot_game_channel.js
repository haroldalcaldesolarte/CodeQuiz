import consumer from "./consumer";

let kahootGameChannel;

function showLoadingScreen(){
  const countdownContainer = document.getElementById("countdown_container");
  const countdownNumber = document.getElementById("countdown_number");

  if (countdownContainer && countdownNumber) {
    countdownContainer.classList.remove("d-none");

    let countdown = 3;
    countdownNumber.textContent = countdown;

    const interval = setInterval(() => {
        countdown -= 1;
        countdownNumber.textContent = countdown;
        
        if (countdown <= 0) {
          clearInterval(interval);
          countdownContainer.classList.add("d-none");
        }
    }, 1000);
  }
}

const initKahootGameChannel = (gameId) => {
  if (kahootGameChannel) {
    consumer.subscriptions.remove(kahootGameChannel);
  }

  function updateQuestionUI(data) {
    const questionContainer = document.getElementById("question_container");
    const answersContainer = document.getElementById("answers_container");
    const sendAnswerContainer = document.getElementById("send_answer_container");
    const indexQuestionContainer = document.getElementById("index_question_container");
    const alertDuplicateAnswerContainer = document.getElementById("alert_duplicate_answer_container");
    let selectedAnswerId = localStorage.getItem("selectedAnswer");
    const overlay = document.getElementById("overlay");
  
    if (overlay) {
      overlay.classList.add("d-none");
    }

    if (alertDuplicateAnswerContainer){
      alertDuplicateAnswerContainer.classList.add("d-none");
    }

    if (indexQuestionContainer){
      indexQuestionContainer.textContent = data.index_question
    }
  
    const existingSubmitButton = document.getElementById("submit_answer_button");
    if (existingSubmitButton) {
      existingSubmitButton.remove();
    }

    const submitButton = document.createElement("button");
    submitButton.id = "submit_answer_button";
    submitButton.classList.add("btn", "btn-primary", "btn-lg");
    submitButton.textContent = "Enviar";
    submitButton.disabled = true;
  
    function selectAnswer(button) {
      document.querySelectorAll(".answer-button").forEach(btn => {
        btn.classList.remove("btn-primary");
        btn.classList.add("btn-outline-primary");
      });
  
      button.classList.remove("btn-outline-primary");
      button.classList.add("btn-primary");
  
      selectedAnswerId = button.dataset.answerId;
      localStorage.setItem("selectedAnswer", selectedAnswerId);
  
      if (submitButton){
        submitButton.disabled = false;
      }
    }
  
    if (questionContainer && answersContainer) {
      questionContainer.textContent = data.question.text;
      answersContainer.innerHTML = "";
  
      data.question.answers.forEach(answer => {
        const button = document.createElement("button");
        button.classList.add("answer-button", "btn", "btn-outline-primary", "btn-lg", "w-100", "py-3", "shadow-sm");
        if(data.host == "true"){
          button.disabled = true;
        }
        button.textContent = answer.answer_text;
        button.dataset.answerId = answer.id;
  
        const answerDiv = document.createElement("div");
        answerDiv.classList.add("col");
        answerDiv.appendChild(button);
        answersContainer.appendChild(answerDiv);
  
        button.addEventListener("click", function () {
          selectAnswer(button);
        });
      });
  
      document.querySelectorAll(".answer-button").forEach(button => {
        button.addEventListener("click", function () {
          selectAnswer(button);
        });
  
        // Volver a marcar el btn seleccionado si el usuario recarga la página
        if (selectedAnswerId && selectedAnswerId === button.dataset.answerId) {
          selectAnswer(button);
        }
      });
  
      submitButton.addEventListener("click", function () {
        if (selectedAnswerId) {
          console.log("Respuesta enviada:", selectedAnswerId);
          const kahootGameId = document.body.dataset.kahootGameId;
  
          fetch(`/kahoot_games/${kahootGameId}/submit_answer`, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
            },
            body: JSON.stringify({ answer_id: selectedAnswerId }),
          })
          .then(response => {
            if (response.ok) {
              console.log("Respuesta procesada correctamente");
              submitButton.disabled = true;
            } else {
              console.error("Error en la respuesta:", response.message);
            }
          })
          .catch(error => console.error("Error enviando respuesta:", error));
        }
      });
  
      sendAnswerContainer.appendChild(submitButton);
    }
  }

  kahootGameChannel = consumer.subscriptions.create(
    { channel: "KahootGameChannel", game_id: gameId },
    {
      connected() {
        console.log(`Conectado a KahootGameChannel ${gameId}`);
      },
      disconnected() {
        console.log("Desconectado de KahootGameChannel");
      },
      received(data) {
        const waiting_container = document.getElementById("waiting_container");
        const in_progress_container = document.getElementById("in_progress_container");
        const finished_container = document.getElementById("finished_container");
        const canceled_container = document.getElementById("canceled_container");
        const overlay = document.getElementById("overlay");
        if (data.type === "new_player") {
          const participantsContainer = document.getElementById("participants_container");

          if (participantsContainer) {
            const colDiv = document.createElement("div");
            colDiv.classList.add("col", "participant");
            colDiv.setAttribute("data-user-id", data.user_id);

            const playerDiv = document.createElement("div");
            playerDiv.className = "p-2 bg-light border rounded";
            playerDiv.innerText = data.username;

            colDiv.appendChild(playerDiv);
            participantsContainer.appendChild(colDiv);
          }
        }
        if (data.type == "update_start_btn"){
          const game_start_btn = document.getElementById("start_game_btn");
          if (game_start_btn){
            if (data.show == "true"){
              game_start_btn.disabled = false;
            }else{
              game_start_btn.disabled = true;
            }
          }
        }
        if (data.type == "game_canceled"){
          if (waiting_container && canceled_container && in_progress_container){
            waiting_container.classList.add("d-none");
            in_progress_container.classList.add("d-none");
            canceled_container.classList.remove("d-none");
          }
        }
        if (data.type === "player_left"){
          const playerDiv = document.querySelector(`.participant[data-user-id='${data.user_id}']`);

          if (playerDiv) {
            playerDiv.remove();
          }
        }
        if (data.type === "player_left_to_host"){
          const alert_player_left = document.getElementById("alert_player_left");
          const counter_participants_container = document.getElementById("counter_participants_container");
          if (alert_player_left) {
            alert_player_left.classList.remove("d-none");
            
            // forzar reflow para aplicar la transición
            void alert_player_left.offsetWidth;
        
            alert_player_left.classList.add("show");

            if(counter_participants_container){
              counter_participants_container.innerText = data.count_participants;
            }
        
            setTimeout(() => {
              alert_player_left.classList.remove("show");
              setTimeout(() => {
                alert_player_left.classList.add("d-none");
              }, 500);
            }, 3000);
          }
        }
        if (data.type === "game_started") {
          if (waiting_container && in_progress_container){
            waiting_container.classList.add("d-none");
            showLoadingScreen(waiting_container, in_progress_container);
            in_progress_container.classList.remove("d-none");
          }
        }
        if (data.type === "new_question") {
          showLoadingScreen();
          updateQuestionUI(data);
        }
        if (data.type === "answer_feedback") {
          const overlay = document.getElementById("overlay");
          const feedbackMessage = document.getElementById("feedback_message");
          const feedbackIcon = document.getElementById("feedback_icon");
          const feedbackScore = document.getElementById("feedback_score");
          const feedbackTotalScore = document.getElementById("feedback_total_score");
          const scoreParticipantContainer = document.getElementById("score_participant_container");

          if (overlay && feedbackMessage && feedbackIcon && feedbackScore && feedbackTotalScore && scoreParticipantContainer) {
            if (data.correct) {
              feedbackMessage.textContent = "¡Respuesta correcta!";
              feedbackIcon.innerHTML = '<i class="fa-solid fa-circle-check text-success fa-3x"></i>';
              feedbackScore.textContent = `Puntos ganados: +${data.question_score}`;
            } else {
              feedbackMessage.textContent = "¡Respuesta incorrecta!";
              feedbackIcon.innerHTML = '<i class="fa-solid fa-circle-xmark text-danger fa-3x"></i>';
              feedbackScore.textContent = "Puntos ganados: 0";
            }
        
            feedbackTotalScore.textContent = `Puntuación total: ${data.total_score}`;
            scoreParticipantContainer.textContent = `${data.total_score}`;
            overlay.classList.remove("d-none");
          }
        }
        if (data.type === "game_finished"){
          const firstPlace = document.getElementById("first_place");
          const secondPlace = document.getElementById("second_place");
          const thirdPlace = document.getElementById("third_place");
          const otherPlayers = document.getElementById("other_players");

          if(in_progress_container){
            in_progress_container.classList.add("d-none");
          }

          if (overlay){
            overlay.classList.add("d-none");
          }
          
          showLoadingScreen();

          if (finished_container && firstPlace && secondPlace && thirdPlace && otherPlayers) {
            const players = data.ranking; // Se asume que `data.ranking` es un array de objetos con { name, score }

            if (players.length > 0) {
              firstPlace.querySelector("#first_username").textContent = players[0]?.username || "-";
              firstPlace.querySelector("#first_score").textContent = players[0]?.score || "0";
            }
            
            if (players.length > 1) {
              secondPlace.querySelector("#second_username").textContent = players[1]?.username || "-";
              secondPlace.querySelector("#second_score").textContent = players[1]?.score || "0";
            }

            if (players.length > 2) {
              thirdPlace.querySelector("#third_username").textContent = players[2]?.username || "-";
              thirdPlace.querySelector("#third_score").textContent = players[2]?.score || "0";
            }

            // Llenar la tabla con los demás jugadores
            otherPlayers.innerHTML = "";
            players.slice(3).forEach((player, index) => {
              const row = `
                <tr>
                  <td>#${index + 4}</td>
                  <td>${player.username}</td>
                  <td>${player.score}</td>
                </tr>`;
              otherPlayers.innerHTML += row;
            });
            
            finished_container.classList.remove("d-none");
          }
        }
        if (data.type === "update_counter"){
          const counterParticipantsContainer =  document.getElementById("counter_participants_response_container");
          if(counterParticipantsContainer){
            counterParticipantsContainer.innerText = data.count;
          }
        }
      }
    }
  );
};

window.initKahootGameChannel = initKahootGameChannel;
window.showLoadingScreen = showLoadingScreen;