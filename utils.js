.pragma library

function safeArrayEdit(arr, index, val) {
    let newArr = JSON.parse(JSON.stringify(arr))
    if (!Array.isArray(newArr)) {
        console.error("newArr argument is not an array")
        return
    }

    index = Number(index)
    if (Number.isNaN(index)) {
        console.error("index argument could not be converted to a number")
        return
    }

    if (index < 0 || index >= arr.length) {
        console.error("index " + index + " is out of bounds")
        return
    }

    newArr[index] = val
    return newArr
}

function isPHOk(statMap, idx) {
    if (idx <0 || idx >= 8) {
        console.error("ERROR: idx must ∈ [0:7]")
        return;
    }

    let item = statMap[idx]
    return !(item["statusUnknown"] || item["bridgeVoltageFault"]
             || item["currentFault"] || item["htVoltageFault"]
             || item["temperatureFault"])
}
