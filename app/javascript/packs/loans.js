import { moneyFormatOnChange } from "./common.js"

var borrowedAmountElement = document.getElementById("loan_borrowed_amount");
borrowedAmountElement.addEventListener("input", moneyFormatOnChange);

var receivedAmountElement = document.getElementById("loan_received_amount");
receivedAmountElement.addEventListener("input", moneyFormatOnChange);
