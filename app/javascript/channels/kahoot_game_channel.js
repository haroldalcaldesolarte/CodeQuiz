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
      }
    }
  );
};

window.initKahootGameChannel = initKahootGameChannel;