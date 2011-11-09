import java.util.ArrayList;
import java.util.List;

public class InputNeuron extends HiddenNeuron
{
  private final double expectedValue;
  public InputNeuron(String id, double expectedValue)
  {
    super(id);
    this.expectedValue = expectedValue;
  }
  
  @Override
  public List<InputNeuron> fire()
  {
    outputValue = calculateOutput(accumulatedSignal);
    
    System.out.println(id + ": " + outputValue);
    return new ArrayList<InputNeuron>();
  }

  public double getExpectedValue()
  {
    return expectedValue;
  }
  
  private final double calculateOutputErrorGradient()
  {
    return 2 * (outputValue - expectedValue);
  }
  
  @Override
  public double getOutputErrorGradient()
  {
    if(outputErrorGradient < 0)
    {
      outputErrorGradient = calculateOutputErrorGradient();
    }
    return outputErrorGradient;
  }
}
