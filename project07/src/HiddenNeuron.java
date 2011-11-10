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
    Network.debug(this + " is firing");
    outputValue = calculateOutput(accumulatedSignal);
    
    List<Neuron> affectedNeurons = new ArrayList<Neuron>();
    for(Axon axon : targetAxons)
    {
      Network.debug("  " + this + " Accumulated Signal: " + accumulatedSignal);
      Network.debug("  " + this + " Output: " + outputValue);
      Network.debug("  " + this + ": Sending value down axon to " + axon.getTarget() + ": " + outputValue);
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
      result += (a.getTarget().getOutputErrorGradient() * errorCausedByInput(a));
    }
    return result;
  }
}
