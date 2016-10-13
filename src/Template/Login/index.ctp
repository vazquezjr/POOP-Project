<!-- LOGIN INDEX PAGE -->
<!-- Background div housing all content within the template -->
<div style="background: url(./img/backgrounds/bg1.jpg);width:100%;height:1000px;margin-top:-100;padding:8%;background-attachment:fixed;">

	<!-- Div holding the main content within the page -->
	<div style="width:60%;padding:5%;margin:0 auto;background: rgba(255, 255, 255, 0.4); border-radius: 20px;">
		
		<!-- Game Logo followed by non-displayed h1 tag -->
		<img src="/img/logo/logo.png" style="width:80%;margin-left:10%;text-align:center;"/><br/>
		<h1 style="text-align:center;display:none;">Onslaught</h1>

		<!-- Game login form -->
		<form action="/menu">
			Username: <input type="text"><br/>
			Password: <input type ="password" size="20"><br/>
			<input style="width:50%;margin-left:25%;" type ="submit" value="Log In" style="align:right;" ><br/>
		</form><br/>
	
		<!-- Create account prompt -->
		<div style="width:50%;text-align:center;margin:0 auto;">
			<p>New to Onslaught? <a href="/login/createaccount" >Sign up here</a> to start playing for free! </p>
		</div>
	
	</div>
</div>