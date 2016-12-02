import processing.serial.*;

import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import java.util.*;

String consumerKey = "xxxx";
String consumerSecret = "xxxx";
String accessToken = "xxxx";
String accessSecret = "xxxx";

Serial ser;

Twitter twitter;
List<Status> statuses = null;
int count = 0;
int interval = 6; // instrumentation_interval better 5(sec)
String answer = "#Lightness0326";
int barcount = 0;
int bar_long;

boolean isGUI = true;
PrintWriter log;
boolean LightState = true;

void init() {
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();  
}

void setup(){
  size(200, 130);
  frameRate(30);
  ser = new Serial(this,"COM3",9600);
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey(consumerKey);
  cb.setOAuthConsumerSecret(consumerSecret);
  cb.setOAuthAccessToken(accessToken);
  cb.setOAuthAccessTokenSecret(accessSecret);

  TwitterFactory tf = new TwitterFactory(cb.build());
  twitter = tf.getInstance();
  
  log = createWriter("Log/"+getDate(1)+"/"+getDate(2)+".csv");
}

void draw(){
  frame.setLocation(1400,780);
   
  background(255,250,158);
  if(isGUI)
  {
    drawprogressbar();
  }
  
  if(count%(interval * 30) == 0)
  {
    getTimeline();
  }
  count++;
  
  bar_long = count - barcount * interval * 30;
  if(bar_long >= interval*30)
  {
    barcount++;
  }
}

void drawprogressbar()
{
  
  
  noStroke();
  float w = map(bar_long,0,interval*30,0,width-width/10);
  fill(50);
  rect(width/20,height/2-10,width-width/10,width/10);
  fill(0,200,0);
  rect(width/20,height/2-10,w,width/10);
}

void getTimeline(){
  try{
    statuses = twitter.getUserTimeline();

    //for(int i = 0; i < 5; i++){
      //text(statuses.get(i).getUser().getName() + "\n" +
      //     statuses.get(i).getText(), 30, 40*(i+1));
    //}
    if(statuses.get(0).getText().equals(answer))
    {
      
      //add control LIGHT program
      ser.write('a');
     
      //change LightState
      LightState =! LightState;
      
      //add local log
      log.println(LightState + "," + getDate(0));
      log.flush();
      
      //destroy tweet
      Status st = twitter.destroyStatus(statuses.get(0).getId());
  
      //tweet
      //Status st = twitter.updateStatus("success" + getDate() + "#5m");
      
      println("success");
    }
    else
    {
      //field
      println("failure");
    }
  }

  catch(TwitterException e){
    println(" Get Usertimeline: " + e +
            " Status code: " + e.getStatusCode());
    exit(); 
  }
}

String getDate(int format) {
  String yearStr,monthStr, dayStr, hourStr, minuteStr, secondStr;
  String ans = "";
 
  yearStr = "" + year();
  if (month() < 10) {
    monthStr = "0" + month();
  } 
  else {
    monthStr = "" + month();
  }
  if (day() < 10) {
    dayStr = "0" + day();
  } 
  else {
    dayStr = "" + day();
  }
  if (hour() < 10) {
    hourStr = "0" + hour();
  } 
  else {
    hourStr = "" + hour();
  }
  if (minute() < 10) {
    minuteStr = "0" + minute();
  } 
  else {
    minuteStr = "" + minute();
  }
  if (second() < 10) {
    secondStr = "0" + second();
  } 
  else {
    secondStr = "" + second();
  }
 
 switch(format)
 {
   case 0:  ans = yearStr + "," + monthStr + "," + dayStr + "," + hourStr + "," + minuteStr + "," + secondStr; break;
   case 1:  ans = yearStr + "" + monthStr + "" +dayStr; break;
   case 2:  ans = yearStr + "" + monthStr + "" +dayStr + "" + hourStr + "" + minuteStr + "" + secondStr; break;
   default: break;
 }
 
 return ans;
}

void mousePressed(){
  isGUI = !isGUI;
}

void dispose(){
   log.close();
}
