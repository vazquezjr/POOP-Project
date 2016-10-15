<!-- VIEW CARD COLLECTION PAGE -->
<!-- Background div housing all content within the template -->
<div style="background:url(/img/backgrounds/bg4.jpg);width:100%;height:100%;padding:1%;background-size:100%;background-attachment:fixed;">


	<!-- This code represents the return button located at the top right of the screen -->
	<a href="/menu">
	<div style="width:40px;height:40px;margin:20px;color:white;float:left;
					background: url(/img/icons/return.png">
	</div>
	</a>


	
	<!-- This code represents the Main collection display on the page -->
	<div style="width:85%;margin:0 auto;background: rgba(255, 255, 255, 0.4); border-radius: 20px;">
	
		<!-- Title -->
		<h1 style="text-align:center;margin-top:2%;"> Collection </h1>
		
		<!-- This code establishes a separator between title and card display -->
		<div style="width: 90%; margin: 5px auto; background-color:#2b2b2b; height:2px;">
		</div>

		<!-- This code generates the card display -->
		<div style="width:100%;height:1000px;">
			
			<!-- For each card in the database... -->
			<?php foreach($card as $crd): ?>
				<!-- Enter logic "does user have card? if user has card, execute below" -->
		
			<!-- Display the card's image as a hyperlink to the card's data -->
			<a href="<$= $crd->cardid ?>">
			<img src="/img/cards/card_id<?= $crd->cardid ?>.png" style="float:left;margin:10px;"/>
			</a>
			
				<!-- Enter logic "if user does not have card..." user will view black & white version of the card instead -->
		
			<?php endforeach; ?>

		</div>
		
	</div>
</div>
