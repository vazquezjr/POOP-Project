<a href="/menu"><div style="width:40px;height:40px;background-color:green;margin:20px;color:white;">
    <p>return</p>
</div></a>
<h1 style="text-align:center;margin-top:5%;"> View Collection </h1>
<div style="width:80%;margin:0 auto;"><table>
    <tr>
        <th>Card Title</th>
        <th>Atk</th>
        <th>Def</th>
        <th>Description</th>
        <th>Image</th>
    </tr>
    <?php foreach($cards as $card): ?>
    <tr>
        <td><?= $this->Html->link($card->title, ['action'=> 'view', $card->id]) ?></td>
        <td><?= $card->atk ?>
        </td>
        <td><?= $card->def ?></td>
        <td><?= $card->description ?></td>
        <td><img src="/img/cards/Image<?php echo $card->id ?>.jpg"/></td>

    </tr>
    <?php endforeach; ?>
</table>
</div>