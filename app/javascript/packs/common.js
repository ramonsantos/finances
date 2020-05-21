export function moneyFormatOnChange() {
  var temp_value = parseInt(event.target.value.replace(/[R][$][ ]/, "").replace(",", "").replace(".", ""))

  if (temp_value === 0) {
    event.target.value = ""
  } else {
    event.target.value = temp_value + ""
  }

  var size = event.target.value.length
  var real = event.target.value.substring(0, (size - 2))
  var cent = event.target.value.substring((size - 2), size)

  event.target.value = formatedValue(real, cent)
}

function formatedValue(real, cent) {
  if (cent.length === 0) {
    return ""
  } else if (cent.length === 1) {
    return `R$ 0,0${cent}`
  } else if (cent.length === 2 && real.length ===0) {
    return `R$ 0,${cent}`
  } else {
    return `R$ ${formatedReal(real)},${cent}`
  }
}

function formatedReal(real) {
  if (real.length >= 4) {
    return `${real.substring(0, real.length - 3)}.${real.substring(real.length - 3)}`
  } else {
    return real
  }
}
