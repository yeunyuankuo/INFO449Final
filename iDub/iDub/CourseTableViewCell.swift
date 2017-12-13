//
//  CourseTableViewCell.swift
//  iDub
//
//  Created by Kiwon Jeong on 2017. 12. 8..
//  Copyright © 2017년 Kiwon Jeong. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    @IBOutlet weak var sectionNumLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var capLabel: UILabel!
    @IBOutlet weak var snlLabel: UILabel!
    @IBOutlet weak var colorBlock: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
