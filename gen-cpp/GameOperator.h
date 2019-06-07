/**
 * Autogenerated by Thrift Compiler (0.12.0)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */
#ifndef GameOperator_H
#define GameOperator_H

#include <thrift/TDispatchProcessor.h>
#include <thrift/async/TConcurrentClientSyncInfo.h>
#include "zgobandServerThrift_types.h"

namespace zgobandRPC {

#ifdef _MSC_VER
  #pragma warning( push )
  #pragma warning (disable : 4250 ) //inheriting methods via dominance 
#endif

class GameOperatorIf {
 public:
  virtual ~GameOperatorIf() {}
  virtual int8_t putChess(const std::string& player1, const std::string& player2, const int32_t deskID, const int8_t seatID, const int8_t row, const int8_t column) = 0;
  virtual bool takeBackReq(const std::string& account, const std::string& otherSide, const int8_t seatID) = 0;
  virtual bool takeBackRespond(const std::string& player1, const std::string& player2, const int8_t seatID, const bool resp) = 0;
  virtual void loseReq(const std::string& player1, const std::string& player2, const int32_t deskID, const int8_t seatID) = 0;
  virtual void drawReq(const std::string& account) = 0;
  virtual void saveGame(const std::string& account) = 0;
};

class GameOperatorIfFactory {
 public:
  typedef GameOperatorIf Handler;

  virtual ~GameOperatorIfFactory() {}

  virtual GameOperatorIf* getHandler(const ::apache::thrift::TConnectionInfo& connInfo) = 0;
  virtual void releaseHandler(GameOperatorIf* /* handler */) = 0;
};

class GameOperatorIfSingletonFactory : virtual public GameOperatorIfFactory {
 public:
  GameOperatorIfSingletonFactory(const ::apache::thrift::stdcxx::shared_ptr<GameOperatorIf>& iface) : iface_(iface) {}
  virtual ~GameOperatorIfSingletonFactory() {}

  virtual GameOperatorIf* getHandler(const ::apache::thrift::TConnectionInfo&) {
    return iface_.get();
  }
  virtual void releaseHandler(GameOperatorIf* /* handler */) {}

 protected:
  ::apache::thrift::stdcxx::shared_ptr<GameOperatorIf> iface_;
};

class GameOperatorNull : virtual public GameOperatorIf {
 public:
  virtual ~GameOperatorNull() {}
  int8_t putChess(const std::string& /* player1 */, const std::string& /* player2 */, const int32_t /* deskID */, const int8_t /* seatID */, const int8_t /* row */, const int8_t /* column */) {
    int8_t _return = 0;
    return _return;
  }
  bool takeBackReq(const std::string& /* account */, const std::string& /* otherSide */, const int8_t /* seatID */) {
    bool _return = false;
    return _return;
  }
  bool takeBackRespond(const std::string& /* player1 */, const std::string& /* player2 */, const int8_t /* seatID */, const bool /* resp */) {
    bool _return = false;
    return _return;
  }
  void loseReq(const std::string& /* player1 */, const std::string& /* player2 */, const int32_t /* deskID */, const int8_t /* seatID */) {
    return;
  }
  void drawReq(const std::string& /* account */) {
    return;
  }
  void saveGame(const std::string& /* account */) {
    return;
  }
};

typedef struct _GameOperator_putChess_args__isset {
  _GameOperator_putChess_args__isset() : player1(false), player2(false), deskID(false), seatID(false), row(false), column(false) {}
  bool player1 :1;
  bool player2 :1;
  bool deskID :1;
  bool seatID :1;
  bool row :1;
  bool column :1;
} _GameOperator_putChess_args__isset;

class GameOperator_putChess_args {
 public:

  GameOperator_putChess_args(const GameOperator_putChess_args&);
  GameOperator_putChess_args& operator=(const GameOperator_putChess_args&);
  GameOperator_putChess_args() : player1(), player2(), deskID(0), seatID(0), row(0), column(0) {
  }

  virtual ~GameOperator_putChess_args() throw();
  std::string player1;
  std::string player2;
  int32_t deskID;
  int8_t seatID;
  int8_t row;
  int8_t column;

  _GameOperator_putChess_args__isset __isset;

  void __set_player1(const std::string& val);

  void __set_player2(const std::string& val);

  void __set_deskID(const int32_t val);

  void __set_seatID(const int8_t val);

  void __set_row(const int8_t val);

  void __set_column(const int8_t val);

  bool operator == (const GameOperator_putChess_args & rhs) const
  {
    if (!(player1 == rhs.player1))
      return false;
    if (!(player2 == rhs.player2))
      return false;
    if (!(deskID == rhs.deskID))
      return false;
    if (!(seatID == rhs.seatID))
      return false;
    if (!(row == rhs.row))
      return false;
    if (!(column == rhs.column))
      return false;
    return true;
  }
  bool operator != (const GameOperator_putChess_args &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const GameOperator_putChess_args & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};


class GameOperator_putChess_pargs {
 public:


  virtual ~GameOperator_putChess_pargs() throw();
  const std::string* player1;
  const std::string* player2;
  const int32_t* deskID;
  const int8_t* seatID;
  const int8_t* row;
  const int8_t* column;

  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};

typedef struct _GameOperator_putChess_result__isset {
  _GameOperator_putChess_result__isset() : success(false), e(false) {}
  bool success :1;
  bool e :1;
} _GameOperator_putChess_result__isset;

class GameOperator_putChess_result {
 public:

  GameOperator_putChess_result(const GameOperator_putChess_result&);
  GameOperator_putChess_result& operator=(const GameOperator_putChess_result&);
  GameOperator_putChess_result() : success(0) {
  }

  virtual ~GameOperator_putChess_result() throw();
  int8_t success;
  InvalidOperation e;

  _GameOperator_putChess_result__isset __isset;

  void __set_success(const int8_t val);

  void __set_e(const InvalidOperation& val);

  bool operator == (const GameOperator_putChess_result & rhs) const
  {
    if (!(success == rhs.success))
      return false;
    if (!(e == rhs.e))
      return false;
    return true;
  }
  bool operator != (const GameOperator_putChess_result &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const GameOperator_putChess_result & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};

typedef struct _GameOperator_putChess_presult__isset {
  _GameOperator_putChess_presult__isset() : success(false), e(false) {}
  bool success :1;
  bool e :1;
} _GameOperator_putChess_presult__isset;

class GameOperator_putChess_presult {
 public:


  virtual ~GameOperator_putChess_presult() throw();
  int8_t* success;
  InvalidOperation e;

  _GameOperator_putChess_presult__isset __isset;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);

};

typedef struct _GameOperator_takeBackReq_args__isset {
  _GameOperator_takeBackReq_args__isset() : account(false), otherSide(false), seatID(false) {}
  bool account :1;
  bool otherSide :1;
  bool seatID :1;
} _GameOperator_takeBackReq_args__isset;

class GameOperator_takeBackReq_args {
 public:

  GameOperator_takeBackReq_args(const GameOperator_takeBackReq_args&);
  GameOperator_takeBackReq_args& operator=(const GameOperator_takeBackReq_args&);
  GameOperator_takeBackReq_args() : account(), otherSide(), seatID(0) {
  }

  virtual ~GameOperator_takeBackReq_args() throw();
  std::string account;
  std::string otherSide;
  int8_t seatID;

  _GameOperator_takeBackReq_args__isset __isset;

  void __set_account(const std::string& val);

  void __set_otherSide(const std::string& val);

  void __set_seatID(const int8_t val);

  bool operator == (const GameOperator_takeBackReq_args & rhs) const
  {
    if (!(account == rhs.account))
      return false;
    if (!(otherSide == rhs.otherSide))
      return false;
    if (!(seatID == rhs.seatID))
      return false;
    return true;
  }
  bool operator != (const GameOperator_takeBackReq_args &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const GameOperator_takeBackReq_args & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};


class GameOperator_takeBackReq_pargs {
 public:


  virtual ~GameOperator_takeBackReq_pargs() throw();
  const std::string* account;
  const std::string* otherSide;
  const int8_t* seatID;

  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};

typedef struct _GameOperator_takeBackReq_result__isset {
  _GameOperator_takeBackReq_result__isset() : success(false) {}
  bool success :1;
} _GameOperator_takeBackReq_result__isset;

class GameOperator_takeBackReq_result {
 public:

  GameOperator_takeBackReq_result(const GameOperator_takeBackReq_result&);
  GameOperator_takeBackReq_result& operator=(const GameOperator_takeBackReq_result&);
  GameOperator_takeBackReq_result() : success(0) {
  }

  virtual ~GameOperator_takeBackReq_result() throw();
  bool success;

  _GameOperator_takeBackReq_result__isset __isset;

  void __set_success(const bool val);

  bool operator == (const GameOperator_takeBackReq_result & rhs) const
  {
    if (!(success == rhs.success))
      return false;
    return true;
  }
  bool operator != (const GameOperator_takeBackReq_result &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const GameOperator_takeBackReq_result & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};

typedef struct _GameOperator_takeBackReq_presult__isset {
  _GameOperator_takeBackReq_presult__isset() : success(false) {}
  bool success :1;
} _GameOperator_takeBackReq_presult__isset;

class GameOperator_takeBackReq_presult {
 public:


  virtual ~GameOperator_takeBackReq_presult() throw();
  bool* success;

  _GameOperator_takeBackReq_presult__isset __isset;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);

};

typedef struct _GameOperator_takeBackRespond_args__isset {
  _GameOperator_takeBackRespond_args__isset() : player1(false), player2(false), seatID(false), resp(false) {}
  bool player1 :1;
  bool player2 :1;
  bool seatID :1;
  bool resp :1;
} _GameOperator_takeBackRespond_args__isset;

class GameOperator_takeBackRespond_args {
 public:

  GameOperator_takeBackRespond_args(const GameOperator_takeBackRespond_args&);
  GameOperator_takeBackRespond_args& operator=(const GameOperator_takeBackRespond_args&);
  GameOperator_takeBackRespond_args() : player1(), player2(), seatID(0), resp(0) {
  }

  virtual ~GameOperator_takeBackRespond_args() throw();
  std::string player1;
  std::string player2;
  int8_t seatID;
  bool resp;

  _GameOperator_takeBackRespond_args__isset __isset;

  void __set_player1(const std::string& val);

  void __set_player2(const std::string& val);

  void __set_seatID(const int8_t val);

  void __set_resp(const bool val);

  bool operator == (const GameOperator_takeBackRespond_args & rhs) const
  {
    if (!(player1 == rhs.player1))
      return false;
    if (!(player2 == rhs.player2))
      return false;
    if (!(seatID == rhs.seatID))
      return false;
    if (!(resp == rhs.resp))
      return false;
    return true;
  }
  bool operator != (const GameOperator_takeBackRespond_args &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const GameOperator_takeBackRespond_args & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};


class GameOperator_takeBackRespond_pargs {
 public:


  virtual ~GameOperator_takeBackRespond_pargs() throw();
  const std::string* player1;
  const std::string* player2;
  const int8_t* seatID;
  const bool* resp;

  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};

typedef struct _GameOperator_takeBackRespond_result__isset {
  _GameOperator_takeBackRespond_result__isset() : success(false) {}
  bool success :1;
} _GameOperator_takeBackRespond_result__isset;

class GameOperator_takeBackRespond_result {
 public:

  GameOperator_takeBackRespond_result(const GameOperator_takeBackRespond_result&);
  GameOperator_takeBackRespond_result& operator=(const GameOperator_takeBackRespond_result&);
  GameOperator_takeBackRespond_result() : success(0) {
  }

  virtual ~GameOperator_takeBackRespond_result() throw();
  bool success;

  _GameOperator_takeBackRespond_result__isset __isset;

  void __set_success(const bool val);

  bool operator == (const GameOperator_takeBackRespond_result & rhs) const
  {
    if (!(success == rhs.success))
      return false;
    return true;
  }
  bool operator != (const GameOperator_takeBackRespond_result &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const GameOperator_takeBackRespond_result & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};

typedef struct _GameOperator_takeBackRespond_presult__isset {
  _GameOperator_takeBackRespond_presult__isset() : success(false) {}
  bool success :1;
} _GameOperator_takeBackRespond_presult__isset;

class GameOperator_takeBackRespond_presult {
 public:


  virtual ~GameOperator_takeBackRespond_presult() throw();
  bool* success;

  _GameOperator_takeBackRespond_presult__isset __isset;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);

};

typedef struct _GameOperator_loseReq_args__isset {
  _GameOperator_loseReq_args__isset() : player1(false), player2(false), deskID(false), seatID(false) {}
  bool player1 :1;
  bool player2 :1;
  bool deskID :1;
  bool seatID :1;
} _GameOperator_loseReq_args__isset;

class GameOperator_loseReq_args {
 public:

  GameOperator_loseReq_args(const GameOperator_loseReq_args&);
  GameOperator_loseReq_args& operator=(const GameOperator_loseReq_args&);
  GameOperator_loseReq_args() : player1(), player2(), deskID(0), seatID(0) {
  }

  virtual ~GameOperator_loseReq_args() throw();
  std::string player1;
  std::string player2;
  int32_t deskID;
  int8_t seatID;

  _GameOperator_loseReq_args__isset __isset;

  void __set_player1(const std::string& val);

  void __set_player2(const std::string& val);

  void __set_deskID(const int32_t val);

  void __set_seatID(const int8_t val);

  bool operator == (const GameOperator_loseReq_args & rhs) const
  {
    if (!(player1 == rhs.player1))
      return false;
    if (!(player2 == rhs.player2))
      return false;
    if (!(deskID == rhs.deskID))
      return false;
    if (!(seatID == rhs.seatID))
      return false;
    return true;
  }
  bool operator != (const GameOperator_loseReq_args &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const GameOperator_loseReq_args & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};


class GameOperator_loseReq_pargs {
 public:


  virtual ~GameOperator_loseReq_pargs() throw();
  const std::string* player1;
  const std::string* player2;
  const int32_t* deskID;
  const int8_t* seatID;

  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};


class GameOperator_loseReq_result {
 public:

  GameOperator_loseReq_result(const GameOperator_loseReq_result&);
  GameOperator_loseReq_result& operator=(const GameOperator_loseReq_result&);
  GameOperator_loseReq_result() {
  }

  virtual ~GameOperator_loseReq_result() throw();

  bool operator == (const GameOperator_loseReq_result & /* rhs */) const
  {
    return true;
  }
  bool operator != (const GameOperator_loseReq_result &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const GameOperator_loseReq_result & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};


class GameOperator_loseReq_presult {
 public:


  virtual ~GameOperator_loseReq_presult() throw();

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);

};

typedef struct _GameOperator_drawReq_args__isset {
  _GameOperator_drawReq_args__isset() : account(false) {}
  bool account :1;
} _GameOperator_drawReq_args__isset;

class GameOperator_drawReq_args {
 public:

  GameOperator_drawReq_args(const GameOperator_drawReq_args&);
  GameOperator_drawReq_args& operator=(const GameOperator_drawReq_args&);
  GameOperator_drawReq_args() : account() {
  }

  virtual ~GameOperator_drawReq_args() throw();
  std::string account;

  _GameOperator_drawReq_args__isset __isset;

  void __set_account(const std::string& val);

  bool operator == (const GameOperator_drawReq_args & rhs) const
  {
    if (!(account == rhs.account))
      return false;
    return true;
  }
  bool operator != (const GameOperator_drawReq_args &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const GameOperator_drawReq_args & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};


class GameOperator_drawReq_pargs {
 public:


  virtual ~GameOperator_drawReq_pargs() throw();
  const std::string* account;

  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};


class GameOperator_drawReq_result {
 public:

  GameOperator_drawReq_result(const GameOperator_drawReq_result&);
  GameOperator_drawReq_result& operator=(const GameOperator_drawReq_result&);
  GameOperator_drawReq_result() {
  }

  virtual ~GameOperator_drawReq_result() throw();

  bool operator == (const GameOperator_drawReq_result & /* rhs */) const
  {
    return true;
  }
  bool operator != (const GameOperator_drawReq_result &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const GameOperator_drawReq_result & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};


class GameOperator_drawReq_presult {
 public:


  virtual ~GameOperator_drawReq_presult() throw();

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);

};

typedef struct _GameOperator_saveGame_args__isset {
  _GameOperator_saveGame_args__isset() : account(false) {}
  bool account :1;
} _GameOperator_saveGame_args__isset;

class GameOperator_saveGame_args {
 public:

  GameOperator_saveGame_args(const GameOperator_saveGame_args&);
  GameOperator_saveGame_args& operator=(const GameOperator_saveGame_args&);
  GameOperator_saveGame_args() : account() {
  }

  virtual ~GameOperator_saveGame_args() throw();
  std::string account;

  _GameOperator_saveGame_args__isset __isset;

  void __set_account(const std::string& val);

  bool operator == (const GameOperator_saveGame_args & rhs) const
  {
    if (!(account == rhs.account))
      return false;
    return true;
  }
  bool operator != (const GameOperator_saveGame_args &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const GameOperator_saveGame_args & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};


class GameOperator_saveGame_pargs {
 public:


  virtual ~GameOperator_saveGame_pargs() throw();
  const std::string* account;

  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};


class GameOperator_saveGame_result {
 public:

  GameOperator_saveGame_result(const GameOperator_saveGame_result&);
  GameOperator_saveGame_result& operator=(const GameOperator_saveGame_result&);
  GameOperator_saveGame_result() {
  }

  virtual ~GameOperator_saveGame_result() throw();

  bool operator == (const GameOperator_saveGame_result & /* rhs */) const
  {
    return true;
  }
  bool operator != (const GameOperator_saveGame_result &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const GameOperator_saveGame_result & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};


class GameOperator_saveGame_presult {
 public:


  virtual ~GameOperator_saveGame_presult() throw();

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);

};

class GameOperatorClient : virtual public GameOperatorIf {
 public:
  GameOperatorClient(apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> prot) {
    setProtocol(prot);
  }
  GameOperatorClient(apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> iprot, apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> oprot) {
    setProtocol(iprot,oprot);
  }
 private:
  void setProtocol(apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> prot) {
  setProtocol(prot,prot);
  }
  void setProtocol(apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> iprot, apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> oprot) {
    piprot_=iprot;
    poprot_=oprot;
    iprot_ = iprot.get();
    oprot_ = oprot.get();
  }
 public:
  apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> getInputProtocol() {
    return piprot_;
  }
  apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> getOutputProtocol() {
    return poprot_;
  }
  int8_t putChess(const std::string& player1, const std::string& player2, const int32_t deskID, const int8_t seatID, const int8_t row, const int8_t column);
  void send_putChess(const std::string& player1, const std::string& player2, const int32_t deskID, const int8_t seatID, const int8_t row, const int8_t column);
  int8_t recv_putChess();
  bool takeBackReq(const std::string& account, const std::string& otherSide, const int8_t seatID);
  void send_takeBackReq(const std::string& account, const std::string& otherSide, const int8_t seatID);
  bool recv_takeBackReq();
  bool takeBackRespond(const std::string& player1, const std::string& player2, const int8_t seatID, const bool resp);
  void send_takeBackRespond(const std::string& player1, const std::string& player2, const int8_t seatID, const bool resp);
  bool recv_takeBackRespond();
  void loseReq(const std::string& player1, const std::string& player2, const int32_t deskID, const int8_t seatID);
  void send_loseReq(const std::string& player1, const std::string& player2, const int32_t deskID, const int8_t seatID);
  void recv_loseReq();
  void drawReq(const std::string& account);
  void send_drawReq(const std::string& account);
  void recv_drawReq();
  void saveGame(const std::string& account);
  void send_saveGame(const std::string& account);
  void recv_saveGame();
 protected:
  apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> piprot_;
  apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> poprot_;
  ::apache::thrift::protocol::TProtocol* iprot_;
  ::apache::thrift::protocol::TProtocol* oprot_;
};

class GameOperatorProcessor : public ::apache::thrift::TDispatchProcessor {
 protected:
  ::apache::thrift::stdcxx::shared_ptr<GameOperatorIf> iface_;
  virtual bool dispatchCall(::apache::thrift::protocol::TProtocol* iprot, ::apache::thrift::protocol::TProtocol* oprot, const std::string& fname, int32_t seqid, void* callContext);
 private:
  typedef  void (GameOperatorProcessor::*ProcessFunction)(int32_t, ::apache::thrift::protocol::TProtocol*, ::apache::thrift::protocol::TProtocol*, void*);
  typedef std::map<std::string, ProcessFunction> ProcessMap;
  ProcessMap processMap_;
  void process_putChess(int32_t seqid, ::apache::thrift::protocol::TProtocol* iprot, ::apache::thrift::protocol::TProtocol* oprot, void* callContext);
  void process_takeBackReq(int32_t seqid, ::apache::thrift::protocol::TProtocol* iprot, ::apache::thrift::protocol::TProtocol* oprot, void* callContext);
  void process_takeBackRespond(int32_t seqid, ::apache::thrift::protocol::TProtocol* iprot, ::apache::thrift::protocol::TProtocol* oprot, void* callContext);
  void process_loseReq(int32_t seqid, ::apache::thrift::protocol::TProtocol* iprot, ::apache::thrift::protocol::TProtocol* oprot, void* callContext);
  void process_drawReq(int32_t seqid, ::apache::thrift::protocol::TProtocol* iprot, ::apache::thrift::protocol::TProtocol* oprot, void* callContext);
  void process_saveGame(int32_t seqid, ::apache::thrift::protocol::TProtocol* iprot, ::apache::thrift::protocol::TProtocol* oprot, void* callContext);
 public:
  GameOperatorProcessor(::apache::thrift::stdcxx::shared_ptr<GameOperatorIf> iface) :
    iface_(iface) {
    processMap_["putChess"] = &GameOperatorProcessor::process_putChess;
    processMap_["takeBackReq"] = &GameOperatorProcessor::process_takeBackReq;
    processMap_["takeBackRespond"] = &GameOperatorProcessor::process_takeBackRespond;
    processMap_["loseReq"] = &GameOperatorProcessor::process_loseReq;
    processMap_["drawReq"] = &GameOperatorProcessor::process_drawReq;
    processMap_["saveGame"] = &GameOperatorProcessor::process_saveGame;
  }

  virtual ~GameOperatorProcessor() {}
};

class GameOperatorProcessorFactory : public ::apache::thrift::TProcessorFactory {
 public:
  GameOperatorProcessorFactory(const ::apache::thrift::stdcxx::shared_ptr< GameOperatorIfFactory >& handlerFactory) :
      handlerFactory_(handlerFactory) {}

  ::apache::thrift::stdcxx::shared_ptr< ::apache::thrift::TProcessor > getProcessor(const ::apache::thrift::TConnectionInfo& connInfo);

 protected:
  ::apache::thrift::stdcxx::shared_ptr< GameOperatorIfFactory > handlerFactory_;
};

class GameOperatorMultiface : virtual public GameOperatorIf {
 public:
  GameOperatorMultiface(std::vector<apache::thrift::stdcxx::shared_ptr<GameOperatorIf> >& ifaces) : ifaces_(ifaces) {
  }
  virtual ~GameOperatorMultiface() {}
 protected:
  std::vector<apache::thrift::stdcxx::shared_ptr<GameOperatorIf> > ifaces_;
  GameOperatorMultiface() {}
  void add(::apache::thrift::stdcxx::shared_ptr<GameOperatorIf> iface) {
    ifaces_.push_back(iface);
  }
 public:
  int8_t putChess(const std::string& player1, const std::string& player2, const int32_t deskID, const int8_t seatID, const int8_t row, const int8_t column) {
    size_t sz = ifaces_.size();
    size_t i = 0;
    for (; i < (sz - 1); ++i) {
      ifaces_[i]->putChess(player1, player2, deskID, seatID, row, column);
    }
    return ifaces_[i]->putChess(player1, player2, deskID, seatID, row, column);
  }

  bool takeBackReq(const std::string& account, const std::string& otherSide, const int8_t seatID) {
    size_t sz = ifaces_.size();
    size_t i = 0;
    for (; i < (sz - 1); ++i) {
      ifaces_[i]->takeBackReq(account, otherSide, seatID);
    }
    return ifaces_[i]->takeBackReq(account, otherSide, seatID);
  }

  bool takeBackRespond(const std::string& player1, const std::string& player2, const int8_t seatID, const bool resp) {
    size_t sz = ifaces_.size();
    size_t i = 0;
    for (; i < (sz - 1); ++i) {
      ifaces_[i]->takeBackRespond(player1, player2, seatID, resp);
    }
    return ifaces_[i]->takeBackRespond(player1, player2, seatID, resp);
  }

  void loseReq(const std::string& player1, const std::string& player2, const int32_t deskID, const int8_t seatID) {
    size_t sz = ifaces_.size();
    size_t i = 0;
    for (; i < (sz - 1); ++i) {
      ifaces_[i]->loseReq(player1, player2, deskID, seatID);
    }
    ifaces_[i]->loseReq(player1, player2, deskID, seatID);
  }

  void drawReq(const std::string& account) {
    size_t sz = ifaces_.size();
    size_t i = 0;
    for (; i < (sz - 1); ++i) {
      ifaces_[i]->drawReq(account);
    }
    ifaces_[i]->drawReq(account);
  }

  void saveGame(const std::string& account) {
    size_t sz = ifaces_.size();
    size_t i = 0;
    for (; i < (sz - 1); ++i) {
      ifaces_[i]->saveGame(account);
    }
    ifaces_[i]->saveGame(account);
  }

};

// The 'concurrent' client is a thread safe client that correctly handles
// out of order responses.  It is slower than the regular client, so should
// only be used when you need to share a connection among multiple threads
class GameOperatorConcurrentClient : virtual public GameOperatorIf {
 public:
  GameOperatorConcurrentClient(apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> prot) {
    setProtocol(prot);
  }
  GameOperatorConcurrentClient(apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> iprot, apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> oprot) {
    setProtocol(iprot,oprot);
  }
 private:
  void setProtocol(apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> prot) {
  setProtocol(prot,prot);
  }
  void setProtocol(apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> iprot, apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> oprot) {
    piprot_=iprot;
    poprot_=oprot;
    iprot_ = iprot.get();
    oprot_ = oprot.get();
  }
 public:
  apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> getInputProtocol() {
    return piprot_;
  }
  apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> getOutputProtocol() {
    return poprot_;
  }
  int8_t putChess(const std::string& player1, const std::string& player2, const int32_t deskID, const int8_t seatID, const int8_t row, const int8_t column);
  int32_t send_putChess(const std::string& player1, const std::string& player2, const int32_t deskID, const int8_t seatID, const int8_t row, const int8_t column);
  int8_t recv_putChess(const int32_t seqid);
  bool takeBackReq(const std::string& account, const std::string& otherSide, const int8_t seatID);
  int32_t send_takeBackReq(const std::string& account, const std::string& otherSide, const int8_t seatID);
  bool recv_takeBackReq(const int32_t seqid);
  bool takeBackRespond(const std::string& player1, const std::string& player2, const int8_t seatID, const bool resp);
  int32_t send_takeBackRespond(const std::string& player1, const std::string& player2, const int8_t seatID, const bool resp);
  bool recv_takeBackRespond(const int32_t seqid);
  void loseReq(const std::string& player1, const std::string& player2, const int32_t deskID, const int8_t seatID);
  int32_t send_loseReq(const std::string& player1, const std::string& player2, const int32_t deskID, const int8_t seatID);
  void recv_loseReq(const int32_t seqid);
  void drawReq(const std::string& account);
  int32_t send_drawReq(const std::string& account);
  void recv_drawReq(const int32_t seqid);
  void saveGame(const std::string& account);
  int32_t send_saveGame(const std::string& account);
  void recv_saveGame(const int32_t seqid);
 protected:
  apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> piprot_;
  apache::thrift::stdcxx::shared_ptr< ::apache::thrift::protocol::TProtocol> poprot_;
  ::apache::thrift::protocol::TProtocol* iprot_;
  ::apache::thrift::protocol::TProtocol* oprot_;
  ::apache::thrift::async::TConcurrentClientSyncInfo sync_;
};

#ifdef _MSC_VER
  #pragma warning( pop )
#endif

} // namespace

#endif