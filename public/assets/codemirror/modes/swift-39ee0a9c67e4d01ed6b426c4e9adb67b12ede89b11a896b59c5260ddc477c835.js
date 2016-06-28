// CodeMirror, copyright (c) by Marijn Haverbeke and others
!function(e){"object"==typeof exports&&"object"==typeof module?e(require("../../lib/codemirror")):"function"==typeof define&&define.amd?define(["../../lib/codemirror"],e):e(CodeMirror)}(function(e){"use strict";function t(e){for(var t={},n=0;n<e.length;n++)t[e[n]]=!0;return t}function n(e,t,n){if(e.sol()&&(t.indented=e.indentation()),e.eatSpace())return null;var r=e.peek();if("/"==r){if(e.match("//"))return e.skipToEnd(),"comment";if(e.match("/*"))return t.tokenize.push(o),o(e,t);if(e.match(x))return"string-2"}if(d.indexOf(r)>-1)return e.next(),"operator";if(m.indexOf(r)>-1)return e.next(),e.match(".."),"punctuation";if('"'==r||"'"==r){e.next();var u=i(r);return t.tokenize.push(u),u(e,t)}if(e.match(h))return"number";if(e.match(_))return"property";if(e.match(v)){var a=e.current();return f.hasOwnProperty(a)?(l.hasOwnProperty(a)&&(t.prev="define"),"keyword"):p.hasOwnProperty(a)?"variable-2":s.hasOwnProperty(a)?"atom":"define"==n?"def":"variable"}return e.next(),null}function r(){var e=0;return function(t,r,i){var o=n(t,r,i);if("punctuation"==o)if("("==t.current())++e;else if(")"==t.current()){if(0==e)return t.backUp(1),r.tokenize.pop(),r.tokenize[r.tokenize.length-1](t,r);--e}return o}}function i(e){return function(t,n){for(var i,o=!1;i=t.next();)if(o){if("("==i)return n.tokenize.push(r()),"string";o=!1}else{if(i==e)break;o="\\"==i}return n.tokenize.pop(),"string"}}function o(e,t){return e.match(/^(?:[^*]|\*(?!\/))*/),e.match("*/")&&t.tokenize.pop(),"comment"}function u(e,t,n){this.prev=e,this.align=t,this.indented=n}function a(e,t){var n=t.match(/^\s*($|\/[\/\*])/,!1)?null:t.column()+1;e.context=new u(e.context,n,e.indented)}function c(e){e.context&&(e.indented=e.context.indented,e.context=e.context.prev)}var f=t(["var","let","class","deinit","enum","extension","func","import","init","protocol","static","struct","subscript","typealias","as","dynamicType","is","new","super","self","Self","Type","__COLUMN__","__FILE__","__FUNCTION__","__LINE__","break","case","continue","default","do","else","fallthrough","if","in","for","return","switch","where","while","associativity","didSet","get","infix","inout","left","mutating","none","nonmutating","operator","override","postfix","precedence","prefix","right","set","unowned","weak","willSet"]),l=t(["var","let","class","enum","extension","func","import","protocol","struct","typealias","dynamicType","for"]),s=t(["Infinity","NaN","undefined","null","true","false","on","off","yes","no","nil","null","this","super"]),p=t(["String","bool","int","string","double","Double","Int","Float","float","public","private","extension"]),d="+-/*%=|&<>#",m=";,.(){}[]",h=/^-?(?:(?:[\d_]+\.[_\d]*|\.[_\d]+|0o[0-7_\.]+|0b[01_\.]+)(?:e-?[\d_]+)?|0x[\d_a-f\.]+(?:p-?[\d_]+)?)/i,v=/^[_A-Za-z$][_A-Za-z$0-9]*/,_=/^[@\.][_A-Za-z$][_A-Za-z$0-9]*/,x=/^\/(?!\s)(?:\/\/)?(?:\\.|[^\/])+\//;e.defineMode("swift",function(e){return{startState:function(){return{prev:null,context:null,indented:0,tokenize:[]}},token:function(e,t){var r=t.prev;t.prev=null;var i=t.tokenize[t.tokenize.length-1]||n,o=i(e,t,r);if(o&&"comment"!=o?t.prev||(t.prev=o):t.prev=r,"punctuation"==o){var u=/[\(\[\{]|([\]\)\}])/.exec(e.current());u&&(u[1]?c:a)(t,e)}return o},indent:function(t,n){var r=t.context;if(!r)return 0;var i=/^[\]\}\)]/.test(n);return null!=r.align?r.align-(i?1:0):r.indented+(i?0:e.indentUnit)},electricInput:/^\s*[\)\}\]]$/,lineComment:"//",blockCommentStart:"/*",blockCommentEnd:"*/"}}),e.defineMIME("text/x-swift","swift")});