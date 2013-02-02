
/*
 * Author: ptantiku
 * 
 * This script shows profile pictures of friends from 
 * 'OrderedFriendsListInitialData' javascript variable 
 * in Facebook page (not all friends) and display them
 * as tiles (or wall-like).
 * 
 * The last function _() does nothing and might cause 
 * an error, but it just works only for fixing bug in IE
 */

/* one-line version */
javascript:var elements=document.getElementsByTagName('script');var element=null;for(var i=0;i<elements.length;i++){if(elements[i].innerHTML.indexOf('OrderedFriendsListInitialData')!==-1){element=elements[i];break;}}var friends=eval(element.innerHTML.match(/OrderedFriendsListInitialData[^:]+:([^\]]+\])/)[1]);var body=document.getElementsByTagName('body')[0];var friend_element=document.createElement("div");friend_element.style.marginTop="60px";friend_element.style.textAlign="center";friend_element.innerHTML="";for(var i=0;i<friends.length;i++){friend_element.innerHTML+='<div style="display:inline-block">'+(i+1)+':<br><a href="https://www.facebook.com/'+friends[i]+'" target="_blank"><img src="https://graph.facebook.com/'+friends[i]+'/picture"></a>';}_(body.insertBefore(friend_element,body.firstChild));

/* multiple-line version */
javascript:
var elements = document.getElementsByTagName('script');
var element = null;
for(var i=0;i<elements.length;i++){
	if(elements[i].innerHTML.indexOf('OrderedFriendsListInitialData')!== -1){
		element = elements[i];break;
	}
}
var friends = eval(element.innerHTML.match(/OrderedFriendsListInitialData[^:]+:([^\]]+\])/)[1]);
var body = document.getElementsByTagName('body')[0];
var friend_element = document.createElement("div");
friend_element.style.marginTop="60px";
friend_element.style.textAlign="center";
friend_element.innerHTML="";
for(var i=0;i<friends.length;i++){
	friend_element.innerHTML+='<div style="display:inline-block">'+(i+1)+':<br><a href="https://www.facebook.com/'+friends[i]+'" target="_blank"><img src="https://graph.facebook.com/'+friends[i]+'/picture"></a>';
}
_(body.insertBefore(friend_element,body.firstChild));
