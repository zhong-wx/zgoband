namespace cpp zgobandRPC
namespace go  zgobandRPC

struct PlayerInfo {
    1: string account,
    2: string nickname,
    3: i32 core,
    4: i32 winRound,
    5: i32 loseRound,
    6: i32 drawRound,
    7: i32 escapeRound
    8: optional bool isReady
}

struct Desk {
    1: i32 deskID,
    2: string player1,
    3: string player2,
    4: bool ready1,
    5: bool ready2
}

service LoginAndReg {
    PlayerInfo login(1:string account, 2:string password),
    bool reg(1:string account, 2:string password, 3:string nickname)
}

service GameHall {
    bool sitDown(1:string account, 2:i32 deskID 3:i32 seat),
    PlayerInfo getSeatInfo(2:i32 deskID, 3:i32 seatID),
    void setReady(1:string account, 2:i32 deskID, 3:i32 seatID, 4:bool isReady),
    i32 leaveSeat(1:string account, 2:i32 deskID, 3:i32 seatID),
    i32 autoMatch(1:string account),
    string getSavedGame(1:string account, 2:string savedGameName),
    list<string> getSavedGameList(1:string account),
    list<Desk> getDeskList()
}

exception InvalidOperation {
    1: string type
    2: string why
}

service GameOperator {
    i8 putChess(1:string player1, 2:string player2, 3:i32 deskID, 4:i8 seatID, 5:i8 row, 6:i8 column) throws (1:InvalidOperation e),
    bool takeBackReq(1:string account, 2:string otherSide, 3:i8 seatID),
    bool takeBackRespond(1:string player1, 2:string player2, 3:i8 seatID, 4:bool resp),
    void loseReq(1:string player1, 2:string player2, 3:i32 deskID, 4:i8 seatID),
    void drawReq(1:string account),
    void saveGame(1:string account)
}
