xmin = 1;
xmax = 5;
ymin = 0;
ymax = 6;

figure;
subplot(2,3,1)
hold on
for i=1:an
    plot(applefeatures(i,1:6),'b-'), title('applefeatures')
    axis([xmin,xmax,ymin,ymax])
end
hold off
subplot(2,3,2)
hold on
for i=1:ban
    plot(bananafeatures(i,1:6),'r-'), title('bananafeatures')
    axis([xmin,xmax,ymin,ymax])

end
hold off
subplot(2,3,3)
hold on
for i=1:bon
    plot(bowlfeatures(i,1:6),'g-'),title('bowlfeatures')
    axis([xmin,xmax,ymin,ymax])

end
hold off
subplot(2,3,4)
hold on
for i=1:mn
    plot(mushroomfeatures(i,1:6),'c-'),title('mushroomfeatures')
    axis([xmin,xmax,ymin,ymax])
end
hold off
subplot(2,3,5)
hold on
for i=1:kn
    plot(keyboardfeatures(i,1:6),'m-'),title('keyboardfeatures')
    axis([xmin,xmax,ymin,ymax])
end
hold off