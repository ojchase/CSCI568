import java.util.ArrayList;
import java.util.List;

public class OutputNeuron extends Neuron
{

  public OutputNeuron(String id)
  {
    super(id);
  }
  
  @Override
  public List<OutputNeuron> fire()
  {
    outputValue = calculateOutput(accumulatedSignal);
    
    System.out.println(id + ": " + outputValue);
    return new ArrayList<OutputNeuron>();
  }
}
