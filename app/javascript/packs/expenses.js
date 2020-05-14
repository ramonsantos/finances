import { moneyFormatOnChange } from "./common.js"

var expenseAmountElement = document.getElementById("expense_amount");
expenseAmountElement.addEventListener("change", moneyFormatOnChange);
