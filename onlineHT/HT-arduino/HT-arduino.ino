// color swirl! connect an RGB LED to the PWM pins as indicated
// in the #defines
// public domain, enjoy!
int r, g, b;
int r_in,g_in,b_in=0;

int r2, g2, b2;
int r_in2,g_in2,b_in2=0;



float sol_valf,dem_valf;

char temp; // Data received from the serial port

String answer ="";


#define REDPIN 6
#define GREENPIN 3
#define BLUEPIN 5


#define REDPIN2 9
#define GREENPIN2 10
#define BLUEPIN2 11
 
#define FADESPEED 10     // make this higher to slow down
 
void setup() {
  Serial.begin(9600); //9600
  while (!Serial)
  {
  // wait for serial port to connect.
  }
  pinMode(REDPIN, OUTPUT);
  pinMode(GREENPIN, OUTPUT);
  pinMode(BLUEPIN, OUTPUT);
  pinMode(REDPIN2, OUTPUT);
  pinMode(GREENPIN2, OUTPUT);
  pinMode(BLUEPIN2, OUTPUT);
}
 
 
void loop() {

//SERIAL READ
  while (Serial.available()) { // If data is available to read,
    temp = Serial.read(); // read it and store it in val
    answer += String(temp);
  }

  if(answer!=""){
    int sepIndex = answer.indexOf(';');
    String sol_val = answer.substring(0, sepIndex);
    String dem_val = answer.substring(sepIndex + 1);
    sol_valf = sol_val.toFloat();
    dem_valf = dem_val.toFloat();
//    Serial.println(sol_valf);
    solarColor(sol_valf);
    demandColor(dem_valf);
    answer="";
  }

}





void slowtransition(int n_pin, int t_in, int t_fin){
//Serial.print(t_in);
//Serial.print(" ");
//Serial.println(t_fin);
  if(t_in > t_fin){//DOWN TRANSITION
    for(int t1=t_in;t1>=t_fin;t1--){
      analogWrite(n_pin,t1);
      delay(10);
    }
  }else if(t_in < t_fin){//UP TRANSITION
    for(int t1=t_in;t1<=t_fin;t1++){
      analogWrite(n_pin,t1);
      delay(10);
    }
  }else{
    analogWrite(n_pin,t_fin);
  }
}



void slowfadeoff(int n_pin, int t){
  for(int t1=t;t1>0;t1--){
    analogWrite(n_pin,t1);
    delay(10);
  }
}

//double slope = 1.0 * (max_out - min_out) / (max_in - min_in)
//output = min_out + slope * (val - min_in)

//output=min_out+(max_out-min_out)/(max_in-min_in)*(val-min_in)

void solarColor(float val_){

    if(val_ == -1){
      r= 0;
      g=0;
      b=0;
      slowtransition(REDPIN,r_in,r);
      slowtransition(GREENPIN,g_in,g);
      slowtransition(BLUEPIN,b_in,b);
      r_in = r;
      g_in = g;
      b_in = b;
     }else if(val_ > 0 && val_ <= 0.3){
//BLUE = NIGHT -> VIOLET = DAWN -> RED = END DAWN
//input: 0->0.3; 
//output: b: 255 -> 0 //g: 0 //r: 0 -> 255

       r = (int)(255*val_/(0.3));
       g = 0;
       b = (int)(255-255*val_/(0.3));
     
      slowtransition(REDPIN,r_in,r);
      slowtransition(GREENPIN,g_in,g);
      slowtransition(BLUEPIN,b_in,b);
      r_in = r;
      g_in = g;
      b_in = b;
    }else if(val_ > 0.3 && val_ <= 0.7){
//RED -> END DAWN; YELLOW -> MORNING
//input: 0.3->0.7; 
//output: b: 0 //g: 0 -> 255 //r: 255
       r = 255;
       g = (int)(255*(val_-0.3)/(0.7-0.3));
       b = 0;
      slowtransition(REDPIN,r_in,r);
      slowtransition(GREENPIN,g_in,g);  
      slowtransition(BLUEPIN,b_in,b);
      r_in = r;
      g_in = g;    
      b_in = b;
    }else if(val_ > 0.7){
//YELLOW -> MORNING; WHITE -> DAY
//input: 0.5->1; 
//output: b: 0 -> 255 //g: 255  //r: 255   
       r = 255;
       g = 255;
       b = (int)(255*(val_-0.7)/(1-0.7));
      slowtransition(REDPIN,r_in,r);
      slowtransition(GREENPIN,g_in,g);  
      slowtransition(BLUEPIN,b_in,b);
      r_in = r;
      g_in = g;       
      b_in = b;
    }
}

void demandColor(float val_){

    if(val_ == -1){
      r2= 0;
      g2=0;
      b2=0;
      slowtransition(REDPIN2,r_in2,r2);
      slowtransition(GREENPIN2,g_in2,g2);
      slowtransition(BLUEPIN2,b_in2,b2);
      r_in2 = r2;
      g_in2 = g2;
      b_in2 = b2;
     }else if(val_ > 0 && val_ <= 0.7){
//BLUE = NIGHT -> VIOLET = DAWN -> RED = END DAWN
//input: 0->0.3; 
//output: b: 255 -> 0 //g: 0 //r: 0 -> 255

       r2 = (int)(255*val_/(0.7));
       g2 = 0;
       b2 = (int)(255-255*val_/(0.7));
     
      slowtransition(REDPIN2,r_in2,r2);
      slowtransition(GREENPIN2,g_in2,g2);
      slowtransition(BLUEPIN2,b_in2,b2);
      r_in2 = r2;
      g_in2 = g2;
      b_in2 = b2;
    }else if(val_ > 0.7 && val_ <= 0.9){
//RED -> END DAWN; YELLOW -> MORNING
//input: 0.3->0.7; 
//output: b: 0 //g: 0 -> 255 //r: 255
       r2 = 255;
       g2 = (int)(255*(val_-0.7)/(0.9-0.7));
       b2 = 0;
      slowtransition(REDPIN2,r_in2,r2);
      slowtransition(GREENPIN2,g_in2,g2);  
      slowtransition(BLUEPIN2,b_in2,b2);
      r_in2 = r2;
      g_in2 = g2;    
      b_in2 = b2;
    }else if(val_ > 0.9){
//YELLOW -> MORNING; WHITE -> DAY
//input: 0.5->1; 
//output: b: 0 -> 255 //g: 255  //r: 255   
       r2 = 255;
       g2 = 255;
       b2 = (int)(255*(val_-0.9)/(1-0.9));
      slowtransition(REDPIN2,r_in2,r2);
      slowtransition(GREENPIN2,g_in2,g2);  
      slowtransition(BLUEPIN2,b_in2,b2);
      r_in2 = r2;
      g_in2 = g2;       
      b_in2 = b2;
    }
}
