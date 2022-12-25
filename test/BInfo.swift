//
//  BInfo.swift
//  test
//
//

import UIKit

class BInfo: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var title: UILabel!
    @IBOutlet var count: UILabel!
    @IBOutlet var submit: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    //버튼을 눌렀을 때 대여하도록
    @IBAction func Onclick(_ sender: UIButton) {
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("BInfo", owner: self, options: nil)
        contentView.fixInView(self)
    }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
