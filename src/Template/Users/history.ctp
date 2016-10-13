
	<!-- Box in te top right corner acting as a return button -->
		<a href="/menu">
		<div style="width:40px;height:40px;margin:20px;color:white;float:left;
						background: url(/img/icons/return.png">
		</div>
		</a>


	<!-- Title -->
		<h1 style="text-align:center;margin-top:5%;"> <?php echo $username ?> Battle History </h1>
	
	
	<!-- Div containing the main table of the page -->
		<div style="width:80%;margin:0 auto;">
			<table>
			
			<!-- Main Table Headers -->
				<tr>
					<th>Date Played</th>
					<th>Win/Lose</th>
					<th>Opponent name</th>
				</tr>
			
			
			
			<!-- Cycle through each game and propogate the table with the corresponding values -->
			<!-- may need logic "foreach game such that id = $user->id" -->
			
				<?php foreach($games as $game): ?>
				<tr>
					<td><?= $game->date ?></td>
					<td><?= $game->result ?></td>
					<td><?= $game->opponentUsername ?></td>

				</tr>
				<?php endforeach; ?>
				
				
			</table>
		</div>
