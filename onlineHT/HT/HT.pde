import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port

// List all the available serial ports:


int d,m,y; //day, month,year
String today,yesterday,url;
String[] temp;
JSONArray json;

int[] sol;
int[] dem;
String[] date;

PFont f;
int font_size = 100;

int ARRAYSIZE = 144; //max array size
int i=1; //var for array

long t;
int time_interval = 1000;





void setup() {
  //SET UP SCREEN SIZE AND BACKGROUND COLOR
  //size(400,400);
  fullScreen();
  background(0,0,0);
  
  //SETUP FONT FOR THE SCREEN TEXT
  f = createFont("Arial",16,true);


  //SET UP OF THE SERIAL PORT
  //uncomment to know which port the arduino is connected.
  //printArray(Serial.list());
  String portName = Serial.list()[0];
  //myPort = new Serial(this, portName, 9600);
  
  //SAVE DATE OF TODAY AND YESTERDAY
  d = day();    // Values from 1 - 31
  m = month();  // Values from 1 - 12
  y = year();
  today = str(y)+"-"+str(m)+"-"+str(d);
  yesterday = str(y)+"-"+str(m)+"-"+str(d-1);

  //READ DATA FROM demanda.ree.es
  url = "https://demanda.ree.es/WSvisionaMovilesPeninsulaRest/resources/demandaGeneracionPeninsula?curva=DEMANDA&fecha="+yesterday;
  temp = loadStrings(url);
  temp[0] = temp[0].substring(34); //5
  temp[0] = temp[0].replaceFirst("\\)", ""); 
  temp[0] = temp[0].replaceFirst("\\;", ""); 
  //println(temp[0]);
  
  //SAVE THE JSON ON A FILE (BACKUP)
  saveStrings("data"+yesterday+".json", temp);
  json = loadJSONArray("data"+yesterday+".json");
  
  
  //EXTRACT DATA AND SAVE INTO THREE USEFUL ARRAYS
  sol = extractInt(json,yesterday,"sol");
  dem = extractInt(json,yesterday,"dem");
  date = extractString(json,yesterday,"ts");
  //println(date);
  t=millis();
}

void draw() {
  background(0,0,0);
  
 // write sol and dem value and send it to arduino
 println(sol[i]+"-"+dem[i]);
 // myPort.write(sol[i]+"-"+dem[i]);         
  println(i);
  
  textFont(f,font_size); //font size
  fill(255,0,0); //fontcolor
  textAlign(CENTER);
  text(date[i],width/2,height/2);  //Display Text
  
  
  if(millis()>=t+time_interval){
    t = millis();
    i = i+1;
  }
  
  if(i==144){
    i=1;
  }
  //background(0);
  //fill(244);
  //text(temp[0],100,100);
}






int[] extractInt(JSONArray json_, String yesterday_, String type_) { 
  json_.size();
  int[] raw_ = new int[1];
  for(int i=0;i< json_.size();i++){
    
    JSONObject item = json.getJSONObject(i); // i over all elements
    //println(item.getString("ts").substring(0,10));
    if(item.getString("ts").substring(0,10).equals(yesterday_)){    
      println(item.getString("ts"));
      expand(raw_);
      raw_ = append(raw_,item.getInt(type_));
    }
  }
  return raw_;
  //return sol_prod_;  // Returns an array of 3 ints: 20, 40, 60 
}


String[] extractString(JSONArray json_, String yesterday_, String type_) { 
  json_.size();
  String[] raw_ = new String[1];
  for(int i=0;i< json_.size();i++){
    JSONObject item = json.getJSONObject(i); // i over all elements
    //println(item.getString("ts").substring(0,10));
    if(item.getString("ts").substring(0,10).equals(yesterday_)){    
      //println(item.getString("ts"));
      expand(raw_);
      raw_ = append(raw_,item.getString(type_));
    }
  }
  return raw_;
  //return sol_prod_;  // Returns an array of 3 ints: 20, 40, 60 
}
