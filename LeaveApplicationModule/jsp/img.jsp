<%@ page session="false" contentType="image/jpeg" %><%@ page import="java.awt.*,java.awt.image.*,java.util.*,javax.imageio.*, com.sun.image.codec.jpeg.*" %>
<%@ page import="cn.dy.base.framework.esb.util.EncryptUtil" %>
<%!
    public Color getRandColor(int fc, int bc) {//给定范围获得随机颜色
        Random random = new Random();
        if (fc > 255) fc = 255;
        if (bc > 255) bc = 255;
        int r = fc + random.nextInt(bc - fc);
        int g = fc + random.nextInt(bc - fc);
        int b = fc + random.nextInt(bc - fc);
        return new Color(r, g, b);
    }

    public int getRandY(int s, int e) {
        Random random = new Random();
        int p = random.nextInt(10) - 5 >= 0 ? 1 : -1;
        int r = random.nextInt(e - s) * p;
        return s + r;
    }
%><%
    response.setDateHeader("expires", 0);
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("pragma", "no-cache");
    String imageHeight = request.getParameter("img_height");
    int iHeight = 31;
    if (imageHeight != null) {
        iHeight = Integer.parseInt(imageHeight.trim());
    }
    //在内存中创建图象
    int iWidth = 65;

    BufferedImage image = new BufferedImage(iWidth, iHeight, BufferedImage.TYPE_INT_RGB);
    // 获取图形上下文
    Graphics g = image.getGraphics();
    g.setColor(Color.white);
    g.fillRect(0, 0, iWidth, iHeight);

    // 画边框
    g.setColor(Color.gray);
    g.drawRect(0, 0, iWidth - 1, iHeight - 1);
    Random random = new Random();
    String rand = Integer.toString(random.nextInt(100000));

    switch (rand.length()) {
        case 1:
            rand = "0000" + rand;
            break;
        case 2:
            rand = "000" + rand;
            break;
        case 3:
            rand = "00" + rand;
            break;
        case 4:
            rand = "0" + rand;
            break;
        default:
            rand = rand.substring(0, 5);
            break;
    }

    //将认证码写入session
    //session.setAttribute("rand_img", rand);


    Cookie cookie=new Cookie("rdm",EncryptUtil.multipleEncode("^rdm^",rand));
    cookie.setPath(request.getContextPath());

    response.addCookie(cookie);

    g.setFont(new Font("Times New Roman", Font.BOLD + Font.ITALIC, 18));
    int startX = 1;
    int startY = 22;
    for (int i = 0; i < rand.length(); i++) {
        g.setColor(getRandColor(30, 150));
        g.drawString(rand.substring(i, i + 1), startX, getRandY(startY, startY + 5));
        FontMetrics fm = g.getFontMetrics();
        //FontMetrics   fm   =   Toolkit.getDefaultToolkit().getFontMetrics(g.getFont());
        startX += fm.stringWidth(rand.substring(i, i + 1));
    }


    //随机产生200个干扰点,使图象中的认证码不易被其它程序探测到
    for (int iIndex = 0; iIndex < 300; iIndex++) {
        int x = random.nextInt(iWidth);
        int y = random.nextInt(iHeight);
        g.setColor(getRandColor(180, 200));
        g.drawLine(x, y, x, y);
    }
    g.dispose();

    //输出图象到页面
  //  ImageIO.write(image, "image/jpeg", response.getOutputStream());
   ServletOutputStream sos = response.getOutputStream();
JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(sos);
encoder.encode(image);
sos.close();
   // return;
%>