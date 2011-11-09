import java.util.ArrayList;
import java.util.List;

public class OutputNeuron extends Neuron
{
  private final double expectedValue;

  public OutputNeuron(String id, double expectedValue)
  {
    super(id);
    this.expectedValue = expectedValue;
  }
  
  public double getExpectedValue()
  {
    return expectedValue;
  }
  
  @Override
  public List<Neuron> fire()
  {
    outputValue = calculateOutput(accumulatedSignal);
    
    System.out.println(id + ": " + outputValue);
    return new ArrayList<Neuron>();
  }
  
  private final double calculateOutputErrorGradient()
  {
    return 2 * (outputValue - expectedValue);
  }
  
  @Override
  public final double getOutputErrorGradient()
  {
    if(outputErrorGradient < 0)
    {
      outputErrorGradient = calculateOutputErrorGradient();
    }
    return outputErrorGradient;
  }
}
