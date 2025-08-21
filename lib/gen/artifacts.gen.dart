// GENERATED – do not modify by hand

// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: unused_element
import "package:blink/model/message/message.dart";import "package:blink/model/message/text.dart";import "package:blink/model/message/tap_back.dart";import "package:blink/model/chat.dart";import "package:artifact/artifact.dart";import "dart:core";
typedef _0=ArtifactCodecUtil;typedef _1=Map<String, dynamic>;typedef _2=List<String>;typedef _3=String;typedef _4=dynamic;typedef _5=int;typedef _6=BlinkMessage;typedef _7=BlinkMessageText;typedef _8=BlinkMessageTapBack;typedef _9=BlinkChat;typedef _a=ArgumentError;typedef _b=bool;typedef _c=List;typedef _d=List<int>;typedef _e=List<dynamic>;
const _2 _S=['time','remote','replyTo','editFrom','_subclass_BlinkMessage','BlinkMessageText','BlinkMessageTapBack','Missing required BlinkMessage."time" in map ','text','Missing required BlinkMessageText."time" in map ','Missing required BlinkMessageText."text" in map ','tbCode','Missing required BlinkMessageTapBack."time" in map ','Missing required BlinkMessageTapBack."tbCode" in map ','peer','messages','Missing required BlinkChat."id" in map ','Missing required BlinkChat."peer" in map ','Missing required BlinkChat."messages" in map '];const _e _V=[false];const _b _T=true;const _b _F=false;const _5 _ = 0;
extension $BlinkMessage on _6{
  _6 get _H=>this;
  _3 toJson({bool pretty=_F})=>_0.j(pretty, toMap);
  _1 toMap(){_;if (_H is _7){return (_H as _7).toMap();}if (_H is _8){return (_H as _8).toMap();}return <_3, _4>{_S[0]:_0.ea(time),_S[1]:_0.ea(remote),_S[2]:_0.ea(replyTo),_S[3]:_0.ea(editFrom),}.$nn;}
  static _6 fromJson(String j)=>fromMap(_0.o(j));
  static _6 fromMap(_1 r){_;_1 m=r.$nn;if(m.$c(_S[4])){String _I=m[_S[4]] as _3;if(_I==_S[5]){return $BlinkMessageText.fromMap(m);}if(_I==_S[6]){return $BlinkMessageTapBack.fromMap(m);}}return _6(time: m.$c(_S[0])? _0.da(m[_S[0]], _5) as _5:(throw _a('${_S[7]}$m.')),remote: m.$c(_S[1]) ?  _0.da(m[_S[1]], _b) as _b : _V[0],replyTo: m.$c(_S[2]) ?  _0.da(m[_S[2]], _3) as _3? : null,editFrom: m.$c(_S[3]) ?  _0.da(m[_S[3]], _3) as _3? : null,);}
  _6 copyWith({_5? time,_5? deltaTime,_b? remote,_b resetRemote=_F,_3? replyTo,_b deleteReplyTo=_F,_3? editFrom,_b deleteEditFrom=_F,}){if (_H is _7){return (_H as _7).copyWith(time: time,deltaTime:deltaTime,remote: remote,resetRemote:resetRemote,replyTo: replyTo,deleteReplyTo:deleteReplyTo,editFrom: editFrom,deleteEditFrom:deleteEditFrom,);}if (_H is _8){return (_H as _8).copyWith(time: time,deltaTime:deltaTime,remote: remote,resetRemote:resetRemote,replyTo: replyTo,deleteReplyTo:deleteReplyTo,editFrom: editFrom,deleteEditFrom:deleteEditFrom,);}return _6(time: deltaTime!=null?(time??_H.time)+deltaTime:time??_H.time,remote: resetRemote?_V[0]:(remote??_H.remote),replyTo: deleteReplyTo?null:(replyTo??_H.replyTo),editFrom: deleteEditFrom?null:(editFrom??_H.editFrom),);}
}
extension $BlinkMessageText on _7{
  _7 get _H=>this;
  _3 toJson({bool pretty=_F})=>_0.j(pretty, toMap);
  _1 toMap(){_;return <_3, _4>{_S[4]: 'BlinkMessageText',_S[0]:_0.ea(time),_S[8]:_0.ea(text),_S[1]:_0.ea(remote),_S[2]:_0.ea(replyTo),_S[3]:_0.ea(editFrom),}.$nn;}
  static _7 fromJson(String j)=>fromMap(_0.o(j));
  static _7 fromMap(_1 r){_;_1 m=r.$nn;return _7(time: m.$c(_S[0])? _0.da(m[_S[0]], _5) as _5:(throw _a('${_S[9]}$m.')),text: m.$c(_S[8])? _0.da(m[_S[8]], _3) as _3:(throw _a('${_S[10]}$m.')),remote: m.$c(_S[1]) ?  _0.da(m[_S[1]], _b) as _b : _V[0],replyTo: m.$c(_S[2]) ?  _0.da(m[_S[2]], _3) as _3? : null,editFrom: m.$c(_S[3]) ?  _0.da(m[_S[3]], _3) as _3? : null,);}
  _7 copyWith({_5? time,_5? deltaTime,_3? text,_b? remote,_b resetRemote=_F,_3? replyTo,_b deleteReplyTo=_F,_3? editFrom,_b deleteEditFrom=_F,})=>_7(time: deltaTime!=null?(time??_H.time)+deltaTime:time??_H.time,text: text??_H.text,remote: resetRemote?_V[0]:(remote??_H.remote),replyTo: deleteReplyTo?null:(replyTo??_H.replyTo),editFrom: deleteEditFrom?null:(editFrom??_H.editFrom),);
}
extension $BlinkMessageTapBack on _8{
  _8 get _H=>this;
  _3 toJson({bool pretty=_F})=>_0.j(pretty, toMap);
  _1 toMap(){_;return <_3, _4>{_S[4]: 'BlinkMessageTapBack',_S[0]:_0.ea(time),_S[11]:_0.ea(tbCode),_S[1]:_0.ea(remote),_S[2]:_0.ea(replyTo),_S[3]:_0.ea(editFrom),}.$nn;}
  static _8 fromJson(String j)=>fromMap(_0.o(j));
  static _8 fromMap(_1 r){_;_1 m=r.$nn;return _8(time: m.$c(_S[0])? _0.da(m[_S[0]], _5) as _5:(throw _a('${_S[12]}$m.')),tbCode: m.$c(_S[11])? _0.da(m[_S[11]], _3) as _3:(throw _a('${_S[13]}$m.')),remote: m.$c(_S[1]) ?  _0.da(m[_S[1]], _b) as _b : _V[0],replyTo: m.$c(_S[2]) ?  _0.da(m[_S[2]], _3) as _3? : null,editFrom: m.$c(_S[3]) ?  _0.da(m[_S[3]], _3) as _3? : null,);}
  _8 copyWith({_5? time,_5? deltaTime,_3? tbCode,_b? remote,_b resetRemote=_F,_3? replyTo,_b deleteReplyTo=_F,_3? editFrom,_b deleteEditFrom=_F,})=>_8(time: deltaTime!=null?(time??_H.time)+deltaTime:time??_H.time,tbCode: tbCode??_H.tbCode,remote: resetRemote?_V[0]:(remote??_H.remote),replyTo: deleteReplyTo?null:(replyTo??_H.replyTo),editFrom: deleteEditFrom?null:(editFrom??_H.editFrom),);
}
extension $BlinkChat on _9{
  _9 get _H=>this;
  _3 toJson({bool pretty=_F})=>_0.j(pretty, toMap);
  _1 toMap(){_;return <_3, _4>{'id':_0.ea(id),_S[14]:_0.ea(peer),_S[15]:messages.$m((e)=> _0.ea(e)).$l,}.$nn;}
  static _9 fromJson(String j)=>fromMap(_0.o(j));
  static _9 fromMap(_1 r){_;_1 m=r.$nn;return _9(id: m.$c('id')? _0.da(m['id'], _3) as _3:(throw _a('${_S[16]}$m.')),peer: m.$c(_S[14])? _0.da(m[_S[14]], _3) as _3:(throw _a('${_S[17]}$m.')),messages: m.$c(_S[15])? (m[_S[15]] as _c).$m((e)=> _0.da(e, _5) as _5).$l:(throw _a('${_S[18]}$m.')),);}
  _9 copyWith({_3? id,_3? peer,_d? messages,_d? appendMessages,_d? removeMessages,})=>_9(id: id??_H.id,peer: peer??_H.peer,messages: (messages??_H.messages).$u(appendMessages,removeMessages),);
}

