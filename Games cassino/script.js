function playGame() {
    const betNumber = parseInt(document.getElementById('betNumber').value);

    
    if (isNaN(betNumber) || betNumber < 0 || betNumber > 36) {
        document.getElementById('result').innerHTML = "Por favor, insira um número entre 0 e 36.";
        return;
    }

    
    const rouletteResult = Math.floor(Math.random() * 37); 
    
    let resultText = `A roleta parou no número ${rouletteResult}. `;
    if (betNumber === rouletteResult) {
        resultText += "<span class='win'>Você ganhou!</span>";
    } else {
        resultText += "<span class='lose'>Você perdeu! Tente novamente.</span>";
    }

    
    document.getElementById('result').innerHTML = resultText;
}
