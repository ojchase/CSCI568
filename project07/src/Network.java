import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;


public class Network
{
  private List<InputNeuron> inputNeurons = Arrays.asList(new InputNeuron("input1", 1), new InputNeuron("input2", 0.25), new InputNeuron("input3", -0.5));
  private List<HiddenNeuron> hiddenNeurons = Arrays.asList(new HiddenNeuron("hidden1"), new HiddenNeuron("hidden2"));
  private List<OutputNeuron> outputNeurons = Arrays.asList(new OutputNeuron("output1", 1), new OutputNeuron("output2", -1), new OutputNeuron("output3", 0));

  public Network()
  {    
    for(Neuron n : inputNeurons)
    {
      for(Neuron m : hiddenNeurons)
      {
        new Axon(n, m);
      }
    }

    for(Neuron n : hiddenNeurons)
    {
      for(Neuron m : outputNeurons)
      {
        new Axon(n, m);
      }
    }

    for(Neuron n : outputNeurons)
    {
        Axon a = new Axon(n, null);
        a.setWeight(1);
    }
  }

  public List<? extends Neuron> getInputNeurons()
  {
    return inputNeurons;
  }
  
  public void train()
  {
    boolean done = false;
    Queue<Neuron> neuronQueue = new LinkedList<Neuron>();
    while(!done)
    {
      neuronQueue.addAll(inputNeurons);
      while(!neuronQueue.isEmpty())
      {
        Neuron firingNeuron = neuronQueue.remove();
        List<? extends Neuron> newNeuronsToFire = firingNeuron.fire();
        for(Neuron n : newNeuronsToFire)
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
        if(outputNeuron.getError() > 0.001*outputNeuron.getExpectedValue())
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
    Queue<Neuron> neuronQueue = new LinkedList<Neuron>();
    neuronQueue.addAll(outputNeurons);
    while(!neuronQueue.isEmpty())
    {
      Neuron backPropogatingNeuron = neuronQueue.remove();
      List<? extends Neuron> newNeuronsToBackPropogate = backPropogatingNeuron.backPropogate();
      for(Neuron n : newNeuronsToBackPropogate)
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
