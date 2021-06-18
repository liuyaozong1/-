//
//  PhotoCollectionViewCell.swift
//  LYZMediaPicker
//
//  Created by 刘耀宗 on 2021/6/18.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    lazy var imgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.frame = contentView.bounds
    }
    
}

extension PhotoCollectionViewCell {
    func configSubviews() {
        setupSubviews()
        measureSubviews()
    }
    
    func setupSubviews() {
        contentView.addSubview(imgView)
    }
    
    func measureSubviews() {
    }
}
