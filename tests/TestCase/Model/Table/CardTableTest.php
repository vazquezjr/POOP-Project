<?php
namespace App\Test\TestCase\Model\Table;

use App\Model\Table\CardTable;
use Cake\ORM\TableRegistry;
use Cake\TestSuite\TestCase;

/**
 * App\Model\Table\CardTable Test Case
 */
class CardTableTest extends TestCase
{

    /**
     * Test subject
     *
     * @var \App\Model\Table\CardTable
     */
    public $Card;

    /**
     * Fixtures
     *
     * @var array
     */
    public $fixtures = [
        'app.card'
    ];

    /**
     * setUp method
     *
     * @return void
     */
    public function setUp()
    {
        parent::setUp();
        $config = TableRegistry::exists('Card') ? [] : ['className' => 'App\Model\Table\CardTable'];
        $this->Card = TableRegistry::get('Card', $config);
    }

    /**
     * tearDown method
     *
     * @return void
     */
    public function tearDown()
    {
        unset($this->Card);

        parent::tearDown();
    }

    /**
     * Test initialize method
     *
     * @return void
     */
    public function testInitialize()
    {
        $this->markTestIncomplete('Not implemented yet.');
    }

    /**
     * Test validationDefault method
     *
     * @return void
     */
    public function testValidationDefault()
    {
        $this->markTestIncomplete('Not implemented yet.');
    }
}
