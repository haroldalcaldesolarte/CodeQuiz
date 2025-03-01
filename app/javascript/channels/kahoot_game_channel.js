import consumer from "./consumer";

let kahootGameChannel;

const initKahootGameChannel = (gameId) => {
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
        if (data.type == "game_canceled"){
          const alertDiv = document.getElementById("kahoot_channel_alert");
          if (alertDiv) {
            alertDiv.textContent = "La partida ha sido cancelada por el host.";
            alertDiv.classList.add("show");
          }

          setTimeout(() => {
            window.location.href = "/kahoot_participants/new";
          }, 3000);
        }
        if (data.type === "player_left"){
          const playerDiv = document.querySelector(`.participant[data-user-id='${data.user_id}']`);
          if (playerDiv) {
            playerDiv.remove();
          }
        }
        if (data.type === "game_started") {
          document.getElementById("waiting_container").style.display = "none";
          document.getElementById("in_progress_container").style.display = "block";
        }
        if (data.type === "new_question") {
          let questionContainer = document.getElementById("question_container");
          let answersContainer = document.getElementById("answers_container");
          let timerContainer = document.getElementById("timer_container");
          let submitButton = document.getElementById("submit_answer_button");
          let selectedAnswerId = localStorage.getItem("selectedAnswer");

          function selectAnswer(button) {
            document.querySelectorAll(".answer-button").forEach(btn => {
              btn.classList.remove("btn-success");
              btn.classList.add("btn-outline-primary");
            });
  
            button.classList.remove("btn-outline-primary");
            button.classList.add("btn-success");
  
            selectedAnswerId = button.dataset.answerId;
            localStorage.setItem("selectedAnswer", selectedAnswerId);
  
            submitButton.disabled = false;
          }
        
          if (questionContainer && answersContainer && timerContainer) {
            questionContainer.textContent = data.question.text;
            answersContainer.innerHTML = "";

            data.question.answers.forEach(answer => {
              const button = document.createElement("button");
              button.classList.add("btn", "btn-outline-primary", "btn-lg", "answer-button", "w-100", "py-3", "shadow-sm");
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
                .then(response => response.json())
                .then(data => {
                  console.log("Respuesta procesada:", data);
                  submitButton.disabled = true;
                })
                .catch(error => console.error("Error enviando respuesta:", error));
              }
            });
          }
        }        
      }
    }
  );
};

window.initKahootGameChannel = initKahootGameChannel;