namespace cpp msgPush

service msgPush {
    void sitDown(1:string account, 2:i32 deskID, 3:i32 seatID),
    void ready(1:string account, 2:i32 deskID, 3:i32 seatID),
    void enterGameHall(1:string account),
    void deskCountChange(1:i8 operate, 2:i32 count)
}
