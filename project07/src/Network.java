import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;


public class Network
{
  private List<Neuron> inputNeurons = Arrays.asList(new Neuron("input1"), new Neuron("input2"), new Neuron("input3"));
  private List<Neuron> hiddenNeurons = Arrays.asList(new Neuron("hidden1"), new Neuron("hidden2"));
  private List<Neuron> outputNeurons = Arrays.asList(new Neuron("output1"), new Neuron("output2"), new Neuron("output3"));

  
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
        new Axon(n, null);
    }
  }

  public List<Neuron> getInputNeurons()
  {
    return inputNeurons;
  }
  
  public static void main(String[] args)
  {
    Network ann = new Network();
    List<Neuron> inputNeurons = ann.getInputNeurons();
    boolean done = false;
    Queue<Neuron> neuronQueue = new LinkedList<Neuron>();
    
    while(!done)
    {
      inputNeurons.get(0).receiveSignal(1);
      inputNeurons.get(1).receiveSignal(0.25);
      inputNeurons.get(2).receiveSignal(-0.5);
      
      neuronQueue.addAll(inputNeurons);
      while(!neuronQueue.isEmpty())
      {
        Neuron firingNeuron = neuronQueue.remove();
        List<Neuron> newNeuronsToFire = firingNeuron.fire();
        for(Neuron n : newNeuronsToFire)
        {
          if(!neuronQueue.contains(n))
          {
            neuronQueue.add(n);
          }
        }
      }
    }
    
    
  }
}
