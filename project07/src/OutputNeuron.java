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

  public double getError()
  {
    return Math.pow(outputValue - expectedValue, 2);
  }
  
  @Override
  public List<Neuron> fire()
  {
    // Clear overall error contribution
    overallErrorContribution = -1;
    
    Network.debug(this + " is firing");
    outputValue = calculateOutput(accumulatedSignal);
    Network.debug("  " + this + " Accumulated Signal: " + accumulatedSignal);
    Network.debug("  " + this + " Output: " + outputValue);
    
    System.out.println(id + " result: " + outputValue);
    return new ArrayList<Neuron>();
  }
  
  @Override
  public final double overallErrorCausedByOutput()
  {
    if(overallErrorContribution < 0)
    {
      overallErrorContribution = 2 * (outputValue - expectedValue);
    }
    return overallErrorContribution;
  }
}
