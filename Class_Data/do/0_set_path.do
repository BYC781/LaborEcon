
clear all
set more off
cap log close
global sysdate = c(current_date)


if "`c(username)'" == "ttyang" {
	
	global do = "C:\nest\Dropbox\causal_data_course\code\Class_Data\do"
    global rawdata = "C:\nest\Dropbox\causal_data_course\code\Class_Data\rawdata"
	global workdata = "C:\nest\Dropbox\causal_data_course\code\Class_Data\rawdata"
    global figure = "C:\nest\Dropbox\Courses\Causal_Inference_Big_Data\Slides\L11_Sythetic_control"

    
}
if "`c(username)'" == "nest" {
    
	global do = "D:\nest\Dropbox\causal_data_course\code\Class_Data\do"
    global rawdata = "D:\nest\Dropbox\causal_data_course\code\Class_Data\rawdata"
	global workdata = "D:\nest\Dropbox\causal_data_course\code\Class_Data\rawdata"
    global figure = "D:\nest\Dropbox\Courses\Causal_Inference_Big_Data\Slides\L11_Sythetic_control"

	
}
if "`c(username)'" == "" {
    
    global do = ""
    global rdata = ""
	global wdata = ""
	
}

if "`c(username)'" == "" {

    global do = ""
    global rdata = ""
	global wdata = ""

	
}

