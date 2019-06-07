var computer = -1
var human = 1
var empty = 0

var chessBoard

function newObjectArray(i, p, value) {
    var tArray = new Array;  //先声明一维
    for(var k=0;k<i;k++){    //一维长度为i,i为变量，可以根据实际情况改变
    tArray[k]=new Array;  //声明二维，每一个一维数组里面的一个元素都是一个数组；
    for(var j=0;j<p;j++){   //一维数组里面每个元素数组可以包含的数量p，p也是一个变量；
    tArray[k][j]=value;    //这里将变量初始化，我这边统一初始化为空，后面在用所需的值覆盖里面的值
     }
    }
    return tArray
}

function getComputerStrategy(cb, lineNumber, columnNumber) {
    chessBoard = cb

    var humanConBoard = calcConBoard(human)
    var computerConBoard = calcConBoard(computer)

    var humanConCountBoard = calConCount(humanConBoard)
    var computerConCountBoard = calConCount(computerConBoard)

    var offScore = calcScore(computerConCountBoard)
    var defScore = calcScore(humanConCountBoard)

    for(var i=1; i<=15; i++) {
        var str = ""
        for(var j=1; j<=15; j++) {
            str += offScore[i][j] + ","
        }
    }
    for(var i=1; i<=15; i++) {
        var str = ""
        for(var j=1; j<=15; j++) {
            str += defScore[i][j] + ","
        }
    }

    var strategy = choose(offScore, defScore)
    chessBoard[strategy.line][strategy.column] = computer
    return strategy
}

function choose(offScore, defScore) {
    var maxOffScore = 0
    var maxDefScore = 0
    var maxOffValArr
    var maxDefValArr
    for(var i=1; i<=15; i++) {
        for(var j=1; j<=15; j++) {
            if(offScore[i][j] > maxOffScore) {
                maxOffValArr = new Array
                maxOffValArr.push({line:i, column:j})
                maxOffScore = offScore[i][j]
            }
            else if(offScore[i][j] == maxOffScore) {
                maxOffValArr.push({line:i, column:j})
            }

            if(defScore[i][j] > maxDefScore) {
                maxDefValArr = new Array
                maxDefValArr.push({line:i, column:j})
                maxDefScore = defScore[i][j]
            }
            else if(defScore[i][j] == maxDefScore) {
                maxDefValArr.push({line:i, column:j})
            }
        }
    }

    var choose
    if(maxOffScore > 80 && maxDefScore > 80) {
        return maxOffValArr[0]
    }
    if(maxOffScore > maxDefScore) {
        var maxDefVal = -1
        for(var i=0; i<maxOffValArr.length; i++) {
            if(defScore[maxOffValArr[i].line][maxOffValArr[i].column] > maxDefVal) {
                choose = maxOffValArr[i]
                maxDefVal = defScore[choose.line][choose.column]
            }
        }
    }
    else if(maxOffScore < maxDefScore) {
        var maxOffScore = -1
        for(var i=0; i<maxDefValArr.length; i++) {
            if(offScore[maxDefValArr[i].line][maxDefValArr[i].column] > maxOffScore) {
                choose = maxDefValArr[i]
                maxOffScore = offScore[choose.line][choose.column]
            }
        }
    }
    else {
        var maxAddVal = -1
        for(var i=0; i<maxOffValArr.length; i++) {
            var line = maxOffValArr[i].line
            var column = maxOffValArr[i].column
            if(defScore[line][column] > maxAddVal) {
                maxAddVal = defScore[line][column]
                choose = maxOffValArr[i]
            }
        }
        for(var i=0; i<maxDefValArr.length; i++) {
            var line = maxDefValArr[i].line
            var column = maxDefValArr[i].column
            if(offScore[line][column] > maxAddVal) {
                maxAddVal = offScore[line][column]
                choose = maxDefValArr[i]
            }
        }
    }
    return choose
}

function calcScore(conCount) {
    var scoreBoard = newObjectArray(16, 16, null)
    for(var i=1; i<=15; i++) {
        for(var j=1; j<=15; j++) {
            var score = 0
            if(chessBoard[i][j] != empty)
                continue
            if(conCount[i][j][0][4] >= 1)
                score = 100
            else if(conCount[i][j][0][3]>=1 || conCount[1][3]>=2 || conCount[0][2]>=2 || (conCount[1][3]>=1 && conCount[0][2]>=1))
                score = 90
            else if(conCount[i][j][0][2]>=1 && conCount[1][2]>=1)
                score = 80
            else if(conCount[i][j][1][3] >= 1)
                score = 70
            else if(conCount[i][j][0][2] >= 1)
                score = 60
            else if(conCount[i][j][0][1] >= 2)
                score = 50
            else if(conCount[i][j][1][2] >= 1)
                score = 40
            else if(conCount[i][j][0][1] >= 1)
                score = 30
            else if(conCount[i][j][1][1] >= 1)
                score = 20
            else if(conCount[i][j][0][0] >= 1)
                score = 15
            else if(conCount[i][j][1][0] >= 1)
                score = 5
            else {
                console.log("line:", i, "column:", j, "score:", score)
            }

            scoreBoard[i][j] = score
        }
    }
    return scoreBoard
}

function calConCount(conBoard) {
    var ret = newObjectArray(16, 16, null)
    for(var i=1; i<=15; i++) {
        for(var j=1; j<=15; j++) {
            if(chessBoard[i][j] != empty)
                continue
            var conSituation = conBoard[i][j]

            var conCount = newObjectArray(2, 5, 0)
            for(var x=0; x<4; x++) {
                if(conSituation[x][0] >= 5)
                    conCount[0][4]++
                else if(conSituation[x][0]>=4 && conSituation[x][1]>=1 && conSituation[x][2]>=1)
                    conCount[0][3]++
                else if(conSituation[x][0]>=4 && (conSituation[x][1]>=1 || conSituation[x][2]>=1))
                    conCount[1][3]++
                else if(conSituation[x][0]>=3 && conSituation[x][1]>=1 && conSituation[x][2]>=1)
                    conCount[0][2]++
                else if(conSituation[x][0]>=3 && (conSituation[x][1]>=1 || conSituation[x][2]>=1))
                    conCount[1][2]++
                else if(conSituation[x][0]>=2 && conSituation[x][1]>=1 && conSituation[x][2]>=1)
                    conCount[0][1]++
                else if(conSituation[x][0]>=2 && (conSituation[x][1]>=1 || conSituation[x][2]>=1))
                    conCount[1][1]++
                else if(conSituation[x][0]>=1 && conSituation[x][1]>=1 && conSituation[x][2]>=1)
                    conCount[0][0]++
                else if(conSituation[x][0]>=1 && (conSituation[x][1]>=1 || conSituation[x][2]>=1))
                    conCount[1][0]++
            }
            ret[i][j] = conCount
        }
    }
    return ret
}

function calcConBoard(playerType) {
    var conBoard = newObjectArray(16, 16, null)

    for(var i=1; i<=15; i++) {
        var situation = calcSituation(chessBoard[i].slice(1, 16), playerType)
        for (var j=1; j<=15; j++) {
            conBoard[i][j] = newObjectArray(4, 3)
            conBoard[i][j][0][0] = situation[j-1].repeatCount
            conBoard[i][j][0][1] = situation[j-1].leftEmptyCount
            conBoard[i][j][0][2] = situation[j-1].rightEmptyCount
        }
    }

    for(var i=1; i<=15; i++) {
        var tarr = new Array
        for(var j=1; j<=15; j++) {
            tarr[j-1] = chessBoard[j][i]
        }
        var situation = calcSituation(tarr, playerType)
        for(var j=1; j<=15; j++) {
            conBoard[j][i][1][0] = situation[j-1].repeatCount
            conBoard[j][i][1][1] = situation[j-1].leftEmptyCount
            conBoard[j][i][1][2] = situation[j-1].rightEmptyCount
        }
    }

    for(var i=11; i>=1; i--) {
        var x = 1
        var y = i
        var arr = new Array
        while(y<=15 && x<=15) {
            arr.push(chessBoard[y][x])
            y++;x++
        }
        var situation = calcSituation(arr, playerType)

        x = 1
        y = i
        var index = 0
        while(y<=15 && x<=15 && index<situation.length) {
            conBoard[y][x][2][0] = situation[index].repeatCount
            conBoard[y][x][2][1] = situation[index].leftEmptyCount
            conBoard[y][x][2][2] = situation[index].rightEmptyCount
            y++;x++;index++
        }
    }
    for(var i=2; i<=11; i++) {
        var x = i
        var y = 1
        var arr = new Array
        while(y<=15 && x<=15) {
            arr.push(chessBoard[y][x])
            y++;x++
        }
        var situation = calcSituation(arr, playerType)

        x = i
        y = 1
        var index=0
        while(y<=15 && x<=15 && index<situation.length) {
            conBoard[y][x][2][0] = situation[index].repeatCount
            conBoard[y][x][2][1] = situation[index].leftEmptyCount
            conBoard[y][x][2][2] = situation[index].rightEmptyCount
            y++;x++;index++
        }
    }

    for(var i=5; i<=15; i++) {
        x = 1;
        y = i;
        var arr = new Array
        while(x<=15 && y>=1) {
            arr.push(chessBoard[y][x])
            x++; y--
        }
        var situation = calcSituation(arr, playerType)

        x = 1
        y = i
        var index = 0
        while(x<=15 && y>=1 && index<situation.length) {
            conBoard[y][x][3][0] = situation[index].repeatCount
            conBoard[y][x][3][1] = situation[index].leftEmptyCount
            conBoard[y][x][3][2] = situation[index].rightEmptyCount
            x++;y--;index++
        }
    }
    for(var i=2; i<=11; i++) {
        var x = i
        var y = 15
        var arr = new Array
        while(x<=15 && y>=1) {
            arr.push(chessBoard[y][x])
            x++;y--
        }

        var situation = calcSituation(arr, playerType)
        x = i
        y = 15
        var index = 0
        while(x<=15 && y>=1 && index<situation.length) {
            conBoard[y][x][3][0] = situation[index].repeatCount
            conBoard[y][x][3][1] = situation[index].leftEmptyCount
            conBoard[y][x][3][2] = situation[index].rightEmptyCount
            x++;y--;index++
        }
    }

    return conBoard
}

function calcSituation(arr, playerType) {
    var situationArr = new Array
    for (var j=0; j<arr.length; j++) {
        situationArr[j] = new Object
    }

    var repeatCountArr = new Array
    repeatCountArr[arr.length-1] = null
    var i=0
    while(i<arr.length) {
        var curIndex = i
        if (arr[i] === playerType) {
            var repeatCount = 0
            while(i<arr.length && arr[i]===playerType) {
                repeatCount++
                i++
            }
            repeatCountArr[curIndex] = repeatCount
            if(i < arr.length) {
                repeatCountArr[i-1] = repeatCount
            }
        }
        i++
    }

    for(i=0; i<arr.length; i++) {
        if(arr[i] === empty) {
            var repeatCount = 1
            if(i>0 && arr[i-1]===playerType) {
                repeatCount += repeatCountArr[i-1]
            }
            if(i<arr.length-1 && arr[i+1]===playerType) {
                repeatCount += repeatCountArr[i+1]
            }
            situationArr[i].repeatCount = repeatCount
        }
    }

    for (i=0; i<arr.length; i++) {
        if (arr[i] !== empty)
            continue
        var leftEmptyCount = 0
        var rightEmptyCount = 0
        var t = i-1
        while(t>=0 && arr[t]!==0-playerType) {
            if (arr[t] === empty)
                leftEmptyCount++
            t--
        }
        t = i+1
        while(t<arr.length && arr[t]!==0-playerType) {
            if (arr[t] === empty)
                rightEmptyCount++
            t++
        }

        situationArr[i].leftEmptyCount = leftEmptyCount
        situationArr[i].rightEmptyCount = rightEmptyCount
    }

    return situationArr
}

function testCalSituation() {
    var testData = newObjectArray(16, 16, empty)
    var t = new Array
    for(var i=0; i<225; i++) {
        t[i] = i
    }

    for(var i=0; i<40; i++) {
        var n = parseInt(Math.random()*(225-i),10);
        var num1 = t[n]
        var line = parseInt(num1 / 15) + 1
        var column = num1 % 15 + 1
        if(i < 20)
            testData[line][column] = 1
        else
            testData[line][column] = -1

        t[n] = t[t.length-1-i]
    }

    chessBoard = testData
}


