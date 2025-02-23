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
          console.log("La partida ha comenzado. Mostrando la vista de juego...");

          document.getElementById("waiting_container").style.display = "none";
          document.getElementById("in_progress_container").style.display = "block";
        }
        if (data.type === "new_question") {

          const questionContainer = document.getElementById("question_container");
          const answersContainer = document.getElementById("answers_container");
          const timerContainer = document.getElementById("timer_container");
        
          if (questionContainer && answersContainer && timerContainer) {
            questionContainer.textContent = data.question.text;
            answersContainer.innerHTML = "";

            data.question.answers.forEach(answer => {
              const button = document.createElement("button");
              button.classList.add("btn", "btn-outline-primary", "btn-lg", "btn-outline-primary", "w-100", "py-3", "shadow-sm");
              button.textContent = answer.answer_text;
              button.dataset.answerId = answer.id;
        
              const answerDiv = document.createElement("div");
              answerDiv.classList.add("col");
              answerDiv.appendChild(button);
              answersContainer.appendChild(answerDiv);
            });
          }
        }        
      }
    }
  );
};

window.initKahootGameChannel = initKahootGameChannel;