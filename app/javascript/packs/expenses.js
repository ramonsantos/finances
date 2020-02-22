var expenseAmountElement = document.getElementById("expense_amount");
expenseAmountElement.addEventListener("change", expenseAmountOnChange);

function expenseAmountOnChange() {
  var temp_value = parseInt(expenseAmountElement.value.replace(/[R][$][ ]/, "").replace(",", ""))

  if (temp_value === 0) {
    expenseAmountElement.value = ""
  } else {
    expenseAmountElement.value = temp_value + ""
  }

  var size = expenseAmountElement.value.length
  var real = expenseAmountElement.value.substring(0, (size - 2))
  var cent = expenseAmountElement.value.substring((size - 2), size)

  expenseAmountElement.value = formated_amount(real, cent)
}

function formated_amount(real, cent) {
  if (cent.length === 0) {
    return ""
  } else if (cent.length === 1) {
    return `R$ 0,0${cent}`
  } else if (cent.length === 2 && real.length ===0) {
    return `R$ 0,${cent}`
  } else {
    return `R$ ${real},${cent}`
  }
}
