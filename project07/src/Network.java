import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;


public class Network
{
  private List<HiddenNeuron> inputNeurons = Arrays.asList(new HiddenNeuron("input1"), new HiddenNeuron("input2"), new HiddenNeuron("input3"));
  private List<HiddenNeuron> hiddenNeurons = Arrays.asList(new HiddenNeuron("hidden1"), new HiddenNeuron("hidden2"));
  private List<OutputNeuron> outputNeurons = Arrays.asList(new OutputNeuron("output1", 1), new OutputNeuron("output2", -1), new OutputNeuron("output3", 0));

  public Network()
  {    
    for(HiddenNeuron n : inputNeurons)
    {
      for(HiddenNeuron m : hiddenNeurons)
      {
        new Axon(n, m);
      }
    }

    for(HiddenNeuron n : hiddenNeurons)
    {
      for(HiddenNeuron m : outputNeurons)
      {
        new Axon(n, m);
      }
    }

    for(HiddenNeuron n : outputNeurons)
    {
        Axon a = new Axon(n, null);
        a.setWeight(1);
    }
  }

  public List<? extends HiddenNeuron> getInputNeurons()
  {
    return inputNeurons;
  }
  
  public void train()
  {
    boolean done = false;
    Queue<HiddenNeuron> neuronQueue = new LinkedList<HiddenNeuron>();
    while(!done)
    {
      inputNeurons.get(0).receiveSignal(1);
      inputNeurons.get(1).receiveSignal(0.25);
      inputNeurons.get(2).receiveSignal(-0.5);
      
      neuronQueue.addAll(inputNeurons);
      while(!neuronQueue.isEmpty())
      {
        HiddenNeuron firingNeuron = neuronQueue.remove();
        List<? extends HiddenNeuron> newNeuronsToFire = firingNeuron.fire();
        for(HiddenNeuron n : newNeuronsToFire)
        {
          if(!neuronQueue.contains(n))
          {
            neuronQueue.add(n);
          }
        }
      }
      done = true;
      for(OutputNeuron outputNeuron : outputNeurons)
      {
        //System.out.println(outputNeuron + ": " + outputNeuron.outputValue);
        if(outputNeuron.getError() > 0.01*outputNeuron.getExpectedValue())
        {
          done = false;
          break;
        }
      }
      if(!done)
        backPropogate();
    }
  }
  
  private void backPropogate()
  {
    Queue<HiddenNeuron> neuronQueue = new LinkedList<HiddenNeuron>();
    neuronQueue.addAll(outputNeurons);
    while(!neuronQueue.isEmpty())
    {
      HiddenNeuron backPropogatingNeuron = neuronQueue.remove();
      List<? extends HiddenNeuron> newNeuronsToBackPropogate = backPropogatingNeuron.backPropogate();
      for(HiddenNeuron n : newNeuronsToBackPropogate)
      {
        if(!neuronQueue.contains(n))
        {
          neuronQueue.add(n);
        }
      }
    }
  }

  public static void main(String[] args)
  {
    Network ann = new Network();
    ann.train();    
  }
}
