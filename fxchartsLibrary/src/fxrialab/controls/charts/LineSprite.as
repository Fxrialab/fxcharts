package fxrialab.controls.charts 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	
	import fxrialab.utils.DrawHelper;
	
	public class LineSprite extends Sprite 
	{
		
		public function LineSprite() 
		{
			super();
		}
		
		private var _data:Object;
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			if(_data == value) return;
			_data = value;
		}
		
		public function draw():void {
			if(data.direction == "horizontal"){
				var pointHorizontal:Sprite = new Sprite();
				pointHorizontal.graphics.clear();
				pointHorizontal.graphics.beginFill(data.stroke, 1);
				pointHorizontal.graphics.drawCircle(0, 0, 3);
				pointHorizontal.x = data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth/2;
				if(data.minValue) {				
					pointHorizontal.y = data.height - data.value - data.marginBottom - data.minValue;
				}else {
					pointHorizontal.y = data.height - data.value - data.marginBottom;
				}

				addChild(pointHorizontal);
			}else {
				var pointVertical:Sprite = new Sprite();
				
				pointVertical.graphics.beginFill(data.stroke, 1);
				pointVertical.graphics.drawCircle(0, 0, 3);
				if(data.minValue) {
					pointVertical.x = data.marginLeft + data.value + data.minValue;
				}else {
					pointVertical.x = data.marginLeft + data.value;
				}
				pointVertical.y = data.height - (data.gapSum + data.barHeightSum + data.marginBottom + data.offSet + data.barHeight/2);
				
				addChild(pointVertical);
			}
		}
		
		private var tooltip:Sprite;
		
		
		public function showTooltip():void {
			
			var txtFieldTooltip:TextField = new TextField();
			var txtFormatTooltip:TextFormat = new TextFormat();
			//var calcPercent:Number = (data.value/data.sumValue * 100);
			
			txtFormatTooltip.align = data.align;
			txtFormatTooltip.font = data.font;
			txtFormatTooltip.size = data.size;
			txtFormatTooltip.color = 0xFFFFFF;
			txtFormatTooltip.leftMargin = txtFormatTooltip.rightMargin = 2;
			
			txtFieldTooltip.selectable = false;
			txtFieldTooltip.height = 20;
			txtFieldTooltip.wordWrap = true;
			txtFieldTooltip.multiline = true;
			txtFieldTooltip.text = data.label +":"+ data.value;
			txtFieldTooltip.setTextFormat(txtFormatTooltip);
			
			tooltip = DrawHelper.Tooltip(txtFieldTooltip.textWidth + 10, txtFieldTooltip.height, 0x1a8948);
			tooltip.addChild(txtFieldTooltip);
			
			var p:Point = new Point(this.mouseX, this.mouseY);
			p = this.localToGlobal(p);
			tooltip.x = p.x - (txtFieldTooltip.textWidth + 10)/2;
			tooltip.y = p.y - tooltip.height - 1;
			
			this.stage.addChild(tooltip);
			
		}
		
		public function hideTooltip():void {
			if(tooltip){
				stage.removeChild(tooltip);
				tooltip = null;	
			}
		}
	}

}