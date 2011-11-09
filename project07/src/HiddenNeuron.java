import java.util.ArrayList;
import java.util.List;

public class HiddenNeuron extends Neuron
{  
  public HiddenNeuron(String id)
  {
    super(id);
  }

  @Override
  public List<Neuron> fire()
  {
    outputValue = calculateOutput(accumulatedSignal);
    
    List<Neuron> affectedNeurons = new ArrayList<Neuron>();
    for(Axon axon : targetAxons)
    {
      axon.sendSignal(outputValue);
      Neuron axonTarget = axon.getTarget();
      if(axonTarget != null)
        affectedNeurons.add(axonTarget);
    }
    return affectedNeurons;
  }
  
  @Override
  public double getOutputErrorGradient()
  {
    if(outputErrorGradient < 0)
      outputErrorGradient = calculateOutputErrorGradient();
    return outputErrorGradient;
  }

  private double calculateOutputErrorGradient()
  {
    double result = 0;
    for(Axon a : targetAxons)
    {
      result += (a.getTarget().getOutputErrorGradient() * errorCausedToTarget(a));
    }
    return result;
  }
}
