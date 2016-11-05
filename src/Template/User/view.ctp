<nav class="large-3 medium-4 columns" id="actions-sidebar">
    <ul class="side-nav">
        <li class="heading"><?= __('Actions') ?></li>
        <li><?= $this->Html->link(__('Edit User'), ['action' => 'edit', $user->username]) ?> </li>
        <li><?= $this->Form->postLink(__('Delete User'), ['action' => 'delete', $user->username], ['confirm' => __('Are you sure you want to delete # {0}?', $user->username)]) ?> </li>
        <li><?= $this->Html->link(__('List User'), ['action' => 'index']) ?> </li>
        <li><?= $this->Html->link(__('New User'), ['action' => 'add']) ?> </li>
    </ul>
</nav>
<div class="user view large-9 medium-8 columns content">
    <h3><?= h($user->username) ?></h3>
    <table class="vertical-table">
        <tr>
            <th scope="row"><?= __('Username') ?></th>
            <td><?= h($user->username) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('Password') ?></th>
            <td><?= h($user->password) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('Wins') ?></th>
            <td><?= $this->Number->format($user->wins) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('Losses') ?></th>
            <td><?= $this->Number->format($user->losses) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('Draws') ?></th>
            <td><?= $this->Number->format($user->draws) ?></td>
        </tr>
    </table>
    <div class="row">
        <h4><?= __('Email') ?></h4>
        <?= $this->Text->autoParagraph(h($user->email)); ?>
    </div>
</div>
