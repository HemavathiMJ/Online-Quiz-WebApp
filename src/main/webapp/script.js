function submitQuiz() {

    let score = 0;

    let q1 = document.querySelector('input[name="q1"]:checked');
    let q2 = document.querySelector('input[name="q2"]:checked');

    if (q1 && q1.value === "New Delhi")
        score++;

    if (q2 && q2.value === "Stack")
        score++;

    document.getElementById("result").innerHTML =
        "Your Score: " + score + "/2";
}