//
//  ViewController.swift
//  LYZMediaPicker
//
//  Created by 刘耀宗 on 2021/6/17.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    let Kwidth: CGFloat = UIScreen.main.bounds.width
    let Kheight: CGFloat = UIScreen.main.bounds.height
    let padding: CGFloat = 5
    let colum: Int = 4
    
    lazy var listData = [UIImage]()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth: CGFloat = (Kwidth - CGFloat(CGFloat((colum + 1)) * padding)) / CGFloat(colum)
        layout.itemSize = CGSize.init(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collecview = UICollectionView(frame: .init(x: 0, y: 100, width: Kwidth, height: Kheight - 100), collectionViewLayout: layout)
        collecview.delegate = self
        collecview.dataSource = self
        collecview.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        return collecview
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        //获取相簿的所有原图  全局队列
        let queue = DispatchQueue.global()
        queue.async {

//            typedef NS_ENUM(NSInteger, PHAssetCollectionType) {
//                PHAssetCollectionTypeAlbum      = 1,///这是里对应的 PHAssetCollectionSubtype 用户自定义的相册文件也在其subtype
//                PHAssetCollectionTypeSmartAlbum = 2,///对应的为系统里的相册文件 下面的200- 211等都为其subtype
//                PHAssetCollectionTypeMoment     = 3,
//            } NS_ENUM_AVAILABLE_IOS(8_0);
//
//
//            typedef NS_ENUM(NSInteger, PHAssetCollectionSubtype) {
//
//                // PHAssetCollectionTypeAlbum regular subtypes
//                PHAssetCollectionSubtypeAlbumRegular         = 2,///
//                PHAssetCollectionSubtypeAlbumSyncedEvent     = 3,
//                PHAssetCollectionSubtypeAlbumSyncedFaces     = 4,面孔
//                PHAssetCollectionSubtypeAlbumSyncedAlbum     = 5,
//                PHAssetCollectionSubtypeAlbumImported        = 6,
//
//                // PHAssetCollectionTypeAlbum shared subtypes
//                PHAssetCollectionSubtypeAlbumMyPhotoStream   = 100,///
//                PHAssetCollectionSubtypeAlbumCloudShared     = 101,///
//
//                // PHAssetCollectionTypeSmartAlbum subtypes         collection.localizedTitle
//                PHAssetCollectionSubtypeSmartAlbumGeneric    = 200,///
//                PHAssetCollectionSubtypeSmartAlbumPanoramas  = 201,///全景照片
//                PHAssetCollectionSubtypeSmartAlbumVideos     = 202,///视频
//                PHAssetCollectionSubtypeSmartAlbumFavorites  = 203,///个人收藏
//                PHAssetCollectionSubtypeSmartAlbumTimelapses = 204,///延时摄影
//                PHAssetCollectionSubtypeSmartAlbumAllHidden  = 205,/// 已隐藏
//                PHAssetCollectionSubtypeSmartAlbumRecentlyAdded = 206,///最近添加
//                PHAssetCollectionSubtypeSmartAlbumBursts     = 207,///连拍快照
//                PHAssetCollectionSubtypeSmartAlbumSlomoVideos = 208,///慢动作
//                PHAssetCollectionSubtypeSmartAlbumUserLibrary = 209,///所有照片
//                PHAssetCollectionSubtypeSmartAlbumSelfPortraits NS_AVAILABLE_IOS(9_0) = 210,///自拍
//                PHAssetCollectionSubtypeSmartAlbumScreenshots NS_AVAILABLE_IOS(9_0) = 211,///屏幕快照
//                                                               = 1000000201///最近删除知道值为（1000000201）但没找到对应的TypedefName
//                // Used for fetching, if you don't care about the exact subtype
//                PHAssetCollectionSubtypeAny = NSIntegerMax /所有类型
//            } NS_ENUM_AVAILABLE_IOS(8_0);

            //获取所有的自定义相簿
            let assetCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
            print("获取到的相簿    \(assetCollections)")
            
            assetCollections.enumerateObjects {[weak self] collection, index, stop in
                print("123213")
                self?.enumerateAssetInAssetCollection(assetCollection: collection, original: false)
            }
            //获得相机胶卷
            let cameraRoll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).lastObject
            if let roll = cameraRoll {
                self.enumerateAssetInAssetCollection(assetCollection: roll, original: false)
            }
            
            
        }
        configSubviews()
    }
    
    //遍历相册中的图片
    func enumerateAssetInAssetCollection(assetCollection: PHAssetCollection,original: Bool) {
        print("相册的名字\(assetCollection.localizedTitle)")
        
        //获取某个相簿中的所有 PHAsset 对象
        let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
        let options = PHImageRequestOptions()
        //调整模式。当size为PHImageManagerMaximumSize时不适用。默认为PHImageRequestOptionsResizeModeFast
        options.resizeMode = .fast
        ////只返回一个结果，阻塞直到可用(或失败)。默认为不
        options.isSynchronous = true
        //交付模式。默认为PHImageRequestOptionsDeliveryModeOpportunistic
        options.deliveryMode = .fastFormat
    
        assets.enumerateObjects { [weak self] asset, index, stop in
            let size = original ? CGSize.init(width: asset.pixelWidth, height: asset.pixelHeight) : .zero
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.default, options: options) { image, info in
                guard let _self = self else {
                    return
                }
                if let img = image {
                    _self.listData.append(img)
                }

            }
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }

    }

}

extension ViewController {
    func configSubviews() {
        setupSubviews()
        measureSubviews()
    }
    
    func setupSubviews() {
        view.addSubview(collectionView)
    }
    
    func measureSubviews() {
        
    }
}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.imgView.image = listData[indexPath.row]
        return cell
    }
    
    
}



