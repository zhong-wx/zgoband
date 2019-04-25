function newObjectArray(i, p) {
    var tArray = new Array;  //先声明一维
    for(var k=0;k<i;k++){    //一维长度为i,i为变量，可以根据实际情况改变
    tArray[k]=new Array;  //声明二维，每一个一维数组里面的一个元素都是一个数组；
    for(var j=0;j<p;j++){   //一维数组里面每个元素数组可以包含的数量p，p也是一个变量；
    tArray[k][j]=new Object;    //这里将变量初始化，我这边统一初始化为空，后面在用所需的值覆盖里面的值
     }
    }
    return tArray
}
