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
int sol_max;
int dem_max;
String sol_s;
String dem_s;

String[] date;

PFont f;
int font_size = 20;

int ARRAYSIZE = 144; //max array size
int i=0; //var for array

long t;
int time_interval = 500;
int end_time = 1000;



//SINE WAVE
/*
int xspacing = 5;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave

float theta = 0.0;  // Start angle at 0
float amplitude = 75.0;  // Height of wave
float period = 200.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues;  // Using an array to store height values for the wave
*/








void setup() {
  //SET UP SCREEN SIZE AND BACKGROUND COLOR
  size(400,400);
  //fullScreen();
  background(0,0,0);
  
  //SETUP FONT FOR THE SCREEN TEXT
  //f = createFont("Arial",16,true);
  f = createFont("futuralightbt.ttf",16,true);


  //SET UP OF THE SERIAL PORT
  //uncomment to know which port the arduino is connected.
  printArray(Serial.list());
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 115200);
  
  //SAVE DATE OF TODAY AND YESTERDAY
  d = day();    // Values from 1 - 31
  m = month();  // Values from 1 - 12
  y = year();
  today = str(y)+"-"+str(m)+"-0"+str(d);
  yesterday = str(y)+"-"+str(m)+"-0"+str(d-1);
  println(yesterday);
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
  
  sol_max = max(sol);
  dem_max = max(dem);
  
  //SIN WAVE
  //w = width+16;
  //dx = (TWO_PI / period) * xspacing;
  //yvalues = new float[w/xspacing];
  
  
  
  t=millis();
 
}




void draw() {
  background(0,0,0);

  if(millis()>=t+time_interval){
    t = millis();
    i = i+1;
  }

    
  if(i==144){
    background(0,0,0);
    myPort.write("-1;-1");
    rectMode(CENTER);  // Set rectMode to CENTER
    fill(0);
    rect(width/2,height/2,width/2,height/2);
    
    if(millis()>=t+end_time){
        i=0;
        t = millis();
    } 
    
  }else if(i<144){
    // write sol and dem value and send it to arduino
    String sol_s = nf(float(sol[i])/sol_max, 0, 2).replace(',', '.');
    String dem_s = nf(float(dem[i])/dem_max, 0, 2).replace(',', '.');
    String str_to_send = sol_s+";"+dem_s;
    //println(str_to_send);
    myPort.write(str_to_send);         

    textFont(f,font_size); //font size
    fill(255,0,0); //fontcolor
    textAlign(CENTER);
    text(date[i],width/2,height/2);  //Display Text
    //calcWave(float(sol[i])/sol_max);
    //renderWave();
  
    
    
  }
}






int[] extractInt(JSONArray json_, String yesterday_, String type_) { 
  json_.size();
  int[] raw_ = new int[0];
  for(int i=0;i< json_.size();i++){
    
    JSONObject item = json.getJSONObject(i); // i over all elements
    if(item.getString("ts").substring(0,10).equals(yesterday_)){    
      expand(raw_);
      raw_ = append(raw_,item.getInt(type_));
    }
  }
  return raw_;
  //return sol_prod_;  // Returns an array of 3 ints: 20, 40, 60 
}


String[] extractString(JSONArray json_, String yesterday_, String type_) { 
  json_.size();
  String[] raw_ = new String[0];
  for(int i=0;i< json_.size();i++){
    JSONObject item = json.getJSONObject(i); // i over all elements
    if(item.getString("ts").substring(0,10).equals(yesterday_)){    
      expand(raw_);
      raw_ = append(raw_,item.getString(type_));
    }
  }
  return raw_;
  //return sol_prod_;  // Returns an array of 3 ints: 20, 40, 60 
}




/*
void calcWave(float ampl_) {
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.02;

  // For every x value, calculate a y value with sine function
  float x = theta;
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = sin(x)*amplitude*ampl_;
    x+=dx;
  }
}

void renderWave() {
  noStroke();
  fill(255);
  // A simple way to draw the wave with an ellipse at each location
  for (int x = 0; x < yvalues.length; x++) {
    ellipse(x*xspacing, height/5+yvalues[x], 5, 5);
  }
}
*/
