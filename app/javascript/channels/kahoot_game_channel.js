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
            colDiv.className = "col";

            const playerDiv = document.createElement("div");
            playerDiv.className = "p-2 bg-light border rounded";
            playerDiv.innerText = data.username;

            colDiv.appendChild(playerDiv);
            participantsContainer.appendChild(colDiv);
          }
        }
      }
    }
  );
};

window.initKahootGameChannel = initKahootGameChannel;