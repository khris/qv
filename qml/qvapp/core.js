var sideLen = 6
var maxIndex = sideLen * sideLen

var blockSize = 50

var blockSrc = "Block.qml"
var blockComponent = Qt.createComponent(blockSrc)

var table = new Array(sideLen)


function initBoard() {
    if(blockComponent.status != Component.Ready) {
        console.log("Error: blockComponent is not ready")
        console.log(blockComponent.errorString())
        return false
    }

    for(var i = 0; i < sideLen; ++i) {
        table[i] = new Array(sideLen)
    }

    for(var col = 0; col < sideLen; ++col) {
        for(var row = 0; row < sideLen; ++row) {
            var newBlock = blockComponent.createObject(container)

            if(newBlock == null) {
                console.log("Error: while create block object")
                console.log(blockComponent.errorString())
                return false
            }

            newBlock.type = Math.floor(Math.random() * 4)
            newBlock.col = col
            newBlock.row = row
            newBlock.x = col * blockSize
            newBlock.y = row * blockSize
            newBlock.width = blockSize
            newBlock.height = blockSize
            newBlock.animating = true

            table[col][row] = newBlock
        }
    }
}

function rotateTable() {
    for(var count = 0; count < container.rotationCount; ++count) {
        for(var col = 0; col < sideLen-1; ++col) {
            for(var row = col+1; row < sideLen; ++row) {
                var temp = table[col][row]
                table[col][row] = table[row][col]
                table[row][col] = temp
            }
        }
        table.reverse();
    }

    for(var col = 0; col < sideLen; ++col) {
        for(var row = 0; row < sideLen; ++row) {
            if(!table[col][row])
                continue

            table[col][row].animating = false
            table[col][row].col = col
            table[col][row].row = row
            table[col][row].x = col * blockSize
            table[col][row].y = row * blockSize
            table[col][row].animating = true
        }
    }

    container.lastRotationCount = container.rotationCount = 0
}

function floodFill(clicked) {
    if(!clicked) {
        deselectAll()
        return
    }

    if(clicked.selected) {
        destroySelected()
        return
    }

    deselectAll()

    var queue = [table[clicked.col][clicked.row]]
    var check = function(block) {
        return block && block.selected === false && block.type == clicked.type
    }

    while(queue.length > 0) {
        var curr = queue.shift()

        if(curr.type != clicked.type)
            continue

        var lBlock = curr.col
        while(lBlock-1 >= 0 && check(table[lBlock-1][curr.row])) { --lBlock }

        var rBlock = curr.col
        while(rBlock+1 < sideLen && check(table[rBlock+1][curr.row])) { ++rBlock }

        for(var col = lBlock; col <= rBlock; ++col) {
            table[col][curr.row].selected = true;

            if(curr.row-1 >= 0 && check(table[col][curr.row-1]))
                queue.push(table[col][curr.row-1])

            if(curr.row+1 < sideLen && check(table[col][curr.row+1]))
                queue.push(table[col][curr.row+1])
        }
    }
}

function deselectAll() {
    for(var col = 0; col < sideLen; ++col) {
        for(var row = 0; row < sideLen; ++row) {
            if(table[col][row])
                table[col][row].selected = false
        }
    }
}

function destroySelected() {
    for(var col = 0; col < sideLen; ++col) {
        for(var row = 0; row < sideLen; ++row) {
            if(table[col][row] && table[col][row].selected) {
                table[col][row].dead = true
                table[col][row] = null
            }
        }
    }
}

function applyGravity() {
    container.state = "aligning"

    var needAligning = false

    for(var col = 0; col < sideLen; ++col) {
        var fall = 0
        for(var row = sideLen-1; row >= 0; --row) {
            if(table[col][row]) {
                if(fall > 0) {
                    table[col][row+fall] = table[col][row]
                    table[col][row] = null
                    table[col][row+fall].row += fall
                    table[col][row+fall].y += fall * blockSize

                    needAligning = true
                }
            } else {
                ++fall
            }
        }
    }

    if(!needAligning)
        container.state = ""
}
