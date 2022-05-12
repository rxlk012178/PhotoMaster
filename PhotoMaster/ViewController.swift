//
//  ViewController.swift
//  PhotoMaster
//
//  Created by 松田結衣 on 2022/05/11.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // 写真表示用View
    @IBOutlet var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // カメラボタンを押した時に呼ばれるメソッド
    @IBAction func onTappedCameraButton() {
        presentPickerController(sourceType: .camera)
    }
    
    // アルバムボタンを押した時に呼ばれるメソッド
    @IBAction func onTappedAlbumButton() {
        presentPickerController(sourceType: .photoLibrary)
    }
    
    // カメラ・アルバムの呼び出しメソッド（カメラorアルバムのソースタイプが引数）
    func presentPickerController(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
        
    }
    
    // 写真が選択された時に呼び出されるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
    // 画像を出力
    photoImageView.image = info[.originalImage] as? UIImage
    }
    
    // 元の画像にテキストを合成するメソッド
    func drawText(image: UIImage) -> UIImage {
      
        // テキストの内容の設定
        let text = "LifeisTech!"
        
        // textFontAttributes: 文字の特性[フォントとサイズ、カラー・スタイル]の設定
        let textFontAttributes = [
            NSAttributedString.Key.font: UIFont(name:"Arial", size: 180)!,
            NSAttributedString.Key.foregroundColor: UIColor.red
        ]

        // グラフィックコンキテスト生成編集を開始
        UIGraphicsBeginImageContext(image.size)
        
        // 読み込んだ写真を書き出す
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // 定義　CGRect(x: [左からのx座標]px, y: [上からのy座標]px, width: [横の長さ]px, height: [縦の長さ]px)
        let margin: CGFloat = 300.0 // 余白
        let textRect = CGRect(x: margin, y: margin, width: image.size.width - margin, height: image.size.height - margin)
        
        // textRectで指定した範囲にtextFontAttributesに従ってtextを書き出す
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        // グラフィックコンキテストの画像を取得
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // グラフィックコンキテストの編集を終了
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // 元の画像にイラストを合成するメソッド
    func drawMaskImage(image: UIImage) -> UIImage {
            
        // マスク画像(保存場所: PhotoMaster > Assets.xcassets)の設定
        let maskImage = UIImage(named: "kirby")!
        
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        let margin: CGFloat = 300.0
        let maskRect  = CGRect(x: image.size.width - maskImage.size.width - margin,
                               y: image.size.height - maskImage.size.height - margin,
                               width: maskImage.size.width, height: maskImage.size.height)
        
        maskImage.draw(in: maskRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // 「テキスト合成」ボタンを押した時に呼ばれるメソッド
        @IBAction func onTappedTextButton() {
            if photoImageView.image != nil {
                photoImageView.image = drawText(image: photoImageView.image!)
            } else {
                print("画像がありません")
            }
        }
    
    // 「イラスト合成」ボタンを押した時に呼ばれるメソッド
        @IBAction func onTappedIllustButton() {
            if photoImageView.image != nil {
                photoImageView.image = drawMaskImage(image: photoImageView.image!)
            } else {
                print("画像がありません")
            }
        }

    // 「アップロード」ボタンを押した時に呼ばれるメソッド
        @IBAction func onTappedUploadButton() {
            if photoImageView.image != nil {
                // 共有するアイテムを設定
                let activityVC = UIActivityViewController(activityItems: [photoImageView.image!,"#PhotoMaster"],applicationActivities: nil)
                self.present(activityVC, animated: true, completion: nil)
            } else {
                print("画像がありません")
            }
        }
}

