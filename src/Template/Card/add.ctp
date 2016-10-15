<nav class="large-3 medium-4 columns" id="actions-sidebar">
    <ul class="side-nav">
        <li class="heading"><?= __('Actions') ?></li>
        <li><?= $this->Html->link(__('List Card'), ['action' => 'index']) ?></li>
    </ul>
</nav>
<div class="card form large-9 medium-8 columns content">
    <?= $this->Form->create($card) ?>
    <fieldset>
        <legend><?= __('Add Card') ?></legend>
        <?php
            echo $this->Form->input('name');
            echo $this->Form->input('picture');
            echo $this->Form->input('description');
            echo $this->Form->input('offensePoints');
            echo $this->Form->input('defensePoints');
        ?>
    </fieldset>
    <?= $this->Form->button(__('Submit')) ?>
    <?= $this->Form->end() ?>
</div>
