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
    // Clear overall error contribution
    overallErrorContribution = -1;
    
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
  public double overallErrorCausedByOutput()
  {
    if(overallErrorContribution < 0)
    {
      overallErrorContribution = 0;
      for(Axon a : targetAxons)
      {
        overallErrorContribution += (a.getTarget().overallErrorCausedByOutput() * a.getTarget().errorInOutputCausedByInput(a));
      }
    }
    return overallErrorContribution;
  }
}
