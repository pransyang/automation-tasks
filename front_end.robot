*** Settings ***
Library 	RequestsLibrary
Library 	Collections
Library 	FakerLibrary 
Library 	String 
Suite Setup    Create Session  jsonplaceholder  https://jsonplaceholder.typicode.com


*** Variables *** 

${base_url}=  	http://216.10.245.166
${isbn}=	abdad	
${aisle}=	2000
${author}=	faker.name

*** Test Cases ***
Scenario: Verify Add a book and verify if it is successfully added 
	Add a new book using Post method 
	Verify the status code of the request
	Verify the success message on the response JSON
	GET the book details

*** Keywords ***

Add a new book using Post method 

	${random_isbn}	Generate Random String    length=4    chars=[NUMBERS]


	${name}		Set Variable	the fault in our stars
	${isbn}		convert to string	${random_isbn}	
	${aisle}	Set Variable	2000
	${author}	FakerLibrary.name
	
	Create Session 	 Addbook   ${base_url}
	${body}= 	create dictionary	name=${name}	isbn=${isbn}	 aisle=${aisle} 	author=${author}
	${header}	create dictionary	Content-Type=application/json

	Log to console	\n
	log to console 		json data:
	Log to console	${body}

	${response}= 	post on session 	Addbook		/Library/Addbook.php 	json=${body}	headers=${header}


	Log to console	\n
	log to console 		json response:
	log to console	${response.content}



	${id}=   catenate	${random_isbn}${aisle}


	Set Global Variable	${response}
	Set Global Variable	${id}
	Set Global Variable 	${header}

Verify the status code of the request

	log to console 	\n
	log to console 	status code : ${response.status_code}


	${status_code}=		convert to string 	${response.status_code}
 
	should be equal   ${status_code}   200
	log to console 	status code is correct !!!

Verify the success message on the response JSON


	${res_body}= 	convert to string 	${response.content}
	should contain 	 ${res_body}	{"Msg":"successfully added","ID":"${id}"}

	log to console 	response message is correct !!!

	Log to console	\n

GET the book details


	${get}=    GET request	 Addbook  	/Library/GetBook.php?AuthorName=${author}	headers=${header}

	${get_status_code}=	convert to string	${get.status_code}

 	should be equal   ${get_status_code}   200

	log to console 	\n
	Log to console 	Get status code:
	log to console	${get_status_code}

	Log to console 	Get response Json:
	log to console	${get.content}
	log to console 	\n
	log to console 	------------- TEST IS SUCCESSFULL -------------
	log to console 	\n 