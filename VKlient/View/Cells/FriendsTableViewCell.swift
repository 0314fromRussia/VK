//
//  FriendsTableViewCell.swift
//  VKlient
//
//  Created by Никита Дмитриев on 25.10.2020.
//  Copyright © 2020 Никита Дмитриев. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var nameLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
