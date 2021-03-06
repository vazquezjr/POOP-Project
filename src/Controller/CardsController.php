<?php
namespace App\Controller;

use App\Controller\AppController;

/**
 * card Controller
 *
 * @property \App\Model\Table\cardTable $card
 */
class CardController extends AppController
{

    /**
     * Index method
     *
     * @return \Cake\Network\Response|null
     */
    public function index()
    {
        $card = $this->paginate($this->card);

        $this->set(compact('card'));
        $this->set('_serialize', ['card']);
    }

    /**
     * View method
     *
     * @param string|null $id Card id.
     * @return \Cake\Network\Response|null
     * @throws \Cake\Datasource\Exception\RecordNotFoundException When record not found.
     */
    public function view($id = null)
    {
    	$card = $this->card->find('all');
    	$card = $this->paginate($this->card);
    	
    	$this->set(compact('card'));
    	$this->set('_serialize', ['card']);
    }

    /**
     * Add method
     *
     * @return \Cake\Network\Response|void Redirects on successful add, renders view otherwise.
     */
    public function add()
    {
        $card = $this->card->newEntity();
        if ($this->request->is('post')) {
            $card = $this->card->patchEntity($card, $this->request->data);
            if ($this->card->save($card)) {
                $this->Flash->success(__('The card has been saved.'));

                return $this->redirect(['action' => 'index']);
            } else {
                $this->Flash->error(__('The card could not be saved. Please, try again.'));
            }
        }
        $this->set(compact('card'));
        $this->set('_serialize', ['card']);
    }

    /**
     * Edit method
     *
     * @param string|null $id Card id.
     * @return \Cake\Network\Response|void Redirects on successful edit, renders view otherwise.
     * @throws \Cake\Network\Exception\NotFoundException When record not found.
     */
    public function edit($id = null)
    {
        $card = $this->card->get($id, [
            'contain' => []
        ]);
        if ($this->request->is(['patch', 'post', 'put'])) {
            $card = $this->card->patchEntity($card, $this->request->data);
            if ($this->card->save($card)) {
                $this->Flash->success(__('The card has been saved.'));

                return $this->redirect(['action' => 'index']);
            } else {
                $this->Flash->error(__('The card could not be saved. Please, try again.'));
            }
        }
        $this->set(compact('card'));
        $this->set('_serialize', ['card']);
    }

    /**
     * Delete method
     *
     * @param string|null $id Card id.
     * @return \Cake\Network\Response|null Redirects to index.
     * @throws \Cake\Datasource\Exception\RecordNotFoundException When record not found.
     */
    public function delete($id = null)
    {
        $this->request->allowMethod(['post', 'delete']);
        $card = $this->card->get($id);
        if ($this->card->delete($card)) {
            $this->Flash->success(__('The card has been deleted.'));
        } else {
            $this->Flash->error(__('The card could not be deleted. Please, try again.'));
        }

        return $this->redirect(['action' => 'index']);
    }
    
    public function images()
    {
    	
    }
}
