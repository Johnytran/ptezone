

import UIKit

@IBDesignable

open class HomeGradientView: UIView
{
  
  
  
  /// Angleº will describe the tilt of gradient.
  @IBInspectable open var angleº: Float = 45.0
    {
    didSet
    {
      // handle negative angles
      if angleº < 0.0 {
        angleº = 360.0 + angleº
      }
      
      // offset of 45 is needed to make logic work
      angleº = angleº + 45
      
      let multiplier = Int(angleº / 360)
      if (multiplier > 0)
      {
        angleº = angleº - Float(360 * multiplier)
      }
      
      if gradientLayer != nil
      {
        self.updatePoints()
      }
    }
  }
  
  /// Color ratio will describe the proportion of colors. It's value ranges from 0.0 to 1.0 default is 0.5.
  @IBInspectable open var colorRatio: Float = 0.5
    {
    didSet
    {
      assert(colorRatio >= 0 || colorRatio <= 1, "Color Ratio: Valid range is from 0.0 to 1.0")
      if gradientLayer != nil
      {
        self.updateLocation()
      }
    }
  }
  
  /// Fade intensity will describe the disperse of colors. It's value ranges from 0.0 to 1.0 default is 0.0.
  @IBInspectable open var fadeIntensity: Float = 0.0
    {
    didSet
    {
      assert(colorRatio >= 0 || colorRatio <= 1, "Fade Intensity: Valid range is from 0.0 to 1.0")
      if gradientLayer != nil
      {
        self.updateLocation()
      }
    }
  }
  
  
  open var gradientLayer: CAGradientLayer?
  
  //MARK:- Designated Initializer
  
  override init(frame: CGRect)
  {
    super.init(frame: frame)
    self.backgroundColor = UIColor.clear
  }
  
  public required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    self.backgroundColor = UIColor.clear
  }
  
  //MARK:- Draw Rect with steps
  
  override open func draw(_ rect: CGRect)
  {
    if gradientLayer == nil
    {
      gradientLayer = CAGradientLayer()
      gradientLayer!.frame = self.bounds
      layer.insertSublayer(gradientLayer!, at: 0)
    }
    self.updateColors()
    self.updatePoints()
    self.updateLocation()
    
  }
  /**
   Step 1
   */
  fileprivate func updateColors()
  {
    gradientLayer!.colors = [UIColor(red: 255/255.0, green: 197/255.0, blue: 255/255.0, alpha: 1.0).cgColor, UIColor(red: 255/255.0, green: 155/255.0, blue: 255/255.0, alpha: 1.0).cgColor]
  }
  /**
   Step 2
   */
  fileprivate func updatePoints()
  {
    let points = startEndPoints()
    gradientLayer!.startPoint = points.0
    gradientLayer!.endPoint = points.1
  }
  /**
   Step 3
   */
  fileprivate func updateLocation()
  {
    let colorLoc = locations()
	gradientLayer!.locations = [NSNumber(value: colorLoc.0), NSNumber(value: colorLoc.1)]
  }
  
  
  fileprivate func startEndPoints() -> (CGPoint, CGPoint)
  {
    var rotCalX: Float = 0.0
    var rotCalY: Float = 0.0
    
    // to convert from 0...360 range to 0...4
    let rotate = angleº / 90
    
    // 1...4 can be understood to denote the four quadrants
    if rotate <= 1
    {
      rotCalY = rotate
    }
    else if rotate <= 2
    {
      rotCalY = 1
      rotCalX = rotate - 1
    }
    else if rotate <= 3
    {
      rotCalX = 1
      rotCalY = 1 - (rotate - 2)
    }
    else if rotate <= 4
    {
      rotCalX = 1 - (rotate - 3)
    }
    
    let start = CGPoint(x: 1 - CGFloat(rotCalY), y: 0 + CGFloat(rotCalX))
    let end = CGPoint(x: 0 + CGFloat(rotCalY), y: 1 - CGFloat(rotCalX))
    
    return (start, end)
  }
  
  fileprivate func locations() -> (Float, Float)
  {
    let divider = fadeIntensity / self.divider()
    return(colorRatio - divider, colorRatio + divider)
  }
  
  fileprivate func divider() -> Float
  {
    if colorRatio == 0.1
    {
      return 10
    }
    if colorRatio < 0.5
    {
      let value = 0.5 - colorRatio + 0.5
      return 1 / (1 - value)
    }
    return 1 / (1 - colorRatio)
  }
}
